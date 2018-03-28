# frozen_string_literal: true
require 'rest-client'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :refresh_issues]
  ORDER_BY_SUPPORT = '(SELECT SUM("issue_transactions"."amount") FROM "issue_transactions" INNER JOIN "issues" ON "issue_transactions"."issue_id"= "issues"."id" WHERE "issues"."project_id" = projects.id) DESC'
  PROJECTS_PER_PAGE = 20

   skip_before_action :verify_authenticity_token

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    full_name = params[:name]
    project_info = JSON.parse(RestClient.get('https://api.github.com/repos/' + full_name).body)

    @project.owner = current_user
    @project.description = project_info['description']
    @project.id = project_info['id']
    @project.name = project_info['name']
    @project.link = project_info['full_name']
    @project.issues = @project.fetch_issues
    @project.status = 1
    @project.save!
  end

  # GET /projects/1/edit
  def edit
  end

  def refresh_issues
    # TODO: Test
    return head :not_found unless @project

    new_issues = @project.fetch_issues

    new_issues.delete_if do |issue|
      Issue.find_by github_id: issue.github_id
    end

    @project.issues += new_issues
    @project.save!

    head :ok
  end

  def explore
    offset = params.permit(:p)[:p]&.to_i || 1
    @current_page = offset
    @page_count = (Project.count / PROJECTS_PER_PAGE.to_f).ceil
    offset -= 1
    @projects =
      if params.permit(:sort)[:sort] == 'recent'
        Project.all.order(created_at: :desc).limit(PROJECTS_PER_PAGE).offset(offset * PROJECTS_PER_PAGE)
      else
        Project.all.order(ORDER_BY_SUPPORT).limit(PROJECTS_PER_PAGE).offset(offset * PROJECTS_PER_PAGE)
      end

    respond_to do |format|
      format.html { render :explore }
      format.json { render json: @projects }
    end
  end

  def search
    offset = params.permit(:p)[:p]&.to_i || 1
    @current_page = offset
    @page_count = (Project.count / PROJECTS_PER_PAGE.to_f).ceil
    offset -= 1
    query = '%' + params.require(:q) + '%'
    @projects = Project.where('LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER (?)', query, query).order(ORDER_BY_SUPPORT).limit(PROJECTS_PER_PAGE).offset(offset * PROJECTS_PER_PAGE)

    respond_to do |format|
      format.html { render :search }
      format.json { render json: @projects }
    end
  rescue ActionController::ParameterMissing
    redirect_to '/explore'
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.fetch(:project, {}).permit(:name, :link, :description, :status)
    end
end
