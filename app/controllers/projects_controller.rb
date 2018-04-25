# frozen_string_literal: true
require 'rest-client'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :refresh_issues, :support_issue, :change_issue_status]
  before_action :set_issue, only: [:support_issue, :change_issue_status]
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
    begin
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


      redirect_to profile_path

    rescue ActiveRecord::RecordNotUnique
      # project already exists
      redirect_to profile_projectexists_path
    end


  end

  # GET /projects/1/edit
  def edit
  end

  def review_issue
    redirect_to new_user_session_path unless user_signed_in?
    @project = Project.find(params[:id])
    @issue = Issue.find(params[:issue_id])

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

    redirect_to edit_project_path(@project)
  end

  def support_issue
    begin
      newamt = params[:amount].to_i * 100
      issue_id = params[:issue_id]
      if newamt > 0
        if newamt> current_user.balance
            redirect_to new_charge_path
        else
          current_user.balance = current_user.balance - newamt
          redirect_back(fallback_location: root_path)
          issue = Issue.find_by id: issue_id
          newTransaction = IssueTransaction.new
          newTransaction.amount = newamt
          newTransaction.user_id = current_user.id
          newTransaction.issue_id = issue_id
          newTransaction.completed = false
          newTransaction.cancelled = false
          newTransaction.save!
          current_user.save!
        end
      end
    rescue
      redirect_back(fallback_location: root_path)
    end

  end


  def cancel_support
    issue_id = params[:issue_id]
    it = IssueTransaction.where(user_id: current_user.id).where(issue_id: issue_id).first
    current_user.balance = current_user.balance.to_i + it.amount
    current_user.save!
    it.destroy
    redirect_back(fallback_location: root_path)

  end

  def change_issue_status
    status = params[:status]

    unless @issue
      render text: 'Not found', status: 404
      return
    end

    @issue.status = status
    @issue.save!

    if status.to_i == 3
      for transaction in @issue.issue_transactions 
          GuestsCleanupJob.set(wait: 1.minutes).perform_later(@project, @issue)
          FeedbackMailer.request_feedback(transaction.user, @project, @issue, @project.owner).deliver_now
      end

    end

    redirect_back(fallback_location: root_path)
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
  def addfunds
    @current_user.balance = @current_user.balance - 1

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

  def feedback_form
    @issue = Issue.find(params[:issue_id])
    @project = Project.find(params[:id])
  end

  def feedback_submit
    @issue = Issue.find(params[:issue_id])
    @project = Project.find(params[:id])
    @feedback = Feedback.new
    if params[:accepted] == "yes"
      @feedback.accepted = TRUE
    else
      @feedback.accepted = FALSE
    end
    @feedback.comment = params[:comment]
    @feedback.issue = Issue.find(params[:issue_id])
    @feedback.user = current_user
    @feedback.weight = 1
    @feedback.project = @project

    @feedback.save!
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
    def set_issue
      @issue = Issue.find(params[:issue_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.fetch(:project, {}).permit(:name, :link, :description, :status)
    end
end
