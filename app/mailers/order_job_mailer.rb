class OrderJobMailer < ApplicationMailer
  default to: ['talha.junaid@algorepublic.com', 'Lucas@saintlbeau.com']

  def start_job_email
    mail(subject: "GHTK Order sweeper notification")
  end

  def end_job_email(message)
    @message = message
    mail(subject: "GHTK Order sweeper notification")
  end
end
