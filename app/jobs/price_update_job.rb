require '../services/price_update_service'
class PriceUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    price_updater = PriceUpdateService.new
    price_updater.run
  end
end
