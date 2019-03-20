class UpdateOrderStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    orders = Order.where.not(ghtk_label: nil)
                  .where.not(ghtk_status: 'Controled')

    UpdateOrderStatusService.new(orders).call if orders.present?
  end
end
