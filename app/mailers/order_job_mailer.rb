class OrderJobMailer < ApplicationMailer
  def start_job_email
    mail(to: 'Lucas@saintlbeau.com', subject: "GHTK Order sweeper notification")
  end

  def end_job_email(message)
    @message = message
    mail(to: 'Lucas@saintlbeau.com', subject: "GHTK Order sweeper notification")
  end
end
