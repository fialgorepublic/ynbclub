class UpdateOrderStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    OrderJobMailer.start_job_email.deliver_now
    begin
      orders = Order.where.not(ghtk_label: nil)
                    .where.not(ghtk_status: 'Controled')
      UpdateOrderStatusService.new(orders).call if orders.present?

      message = "Orders job is completed successfully."
    rescue => ex
      message = "Order status job failed because of following issue: #{ex.message}"
    end

    OrderJobMailer.end_job_email(message).deliver_now
  end
end
