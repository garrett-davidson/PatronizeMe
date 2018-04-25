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
    
  end
end
