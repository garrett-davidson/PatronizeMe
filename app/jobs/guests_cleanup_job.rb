class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    logger.debug args[0]
  end
end
