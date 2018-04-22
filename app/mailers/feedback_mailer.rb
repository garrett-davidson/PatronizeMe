class FeedbackMailer < ApplicationMailer
  default from: 'getpatronizeme@gmail.com'

  def request_feedback(user, project, issue, developer)
    @user = user
    @project = project
    @issue = issue
    @developer = developer
    mail(to: @user.email, subject: @issue.name + ' has been completed on ' + @project.name)
  end
end
