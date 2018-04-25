class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    project = args[0]
    issue = args[1]
    logger.debug project.id
    logger.debug issue.id


    percentage = issue.percentage
    logger.debug percentage

    if percentage >= 0.5 then
        #payout to the developer
        issue.status = 5
        issue.save
        owner = User.find(project.owner_id)
        owner.balance += (issue.total_funding * 100)
        owner.save
        
        logger.debug 'issue has been completed'
    else
        issue.status = 1
        issue.save
        logger.debug 'issue has been reset'
    end


  end
end
