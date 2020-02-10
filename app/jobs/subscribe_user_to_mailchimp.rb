class SubscribeUserToMailchimp < ActiveJob::Base
  queue_as :default
  def perform(user)
    begin
    @list_id = "7f6c83cb93"
    gibbon = Gibbon::Request.new

    gibbon.lists(@list_id).members.create(
      body: {
        email_address: user.email,
        status: "subscribed",
        merge_fields: {FNAME: user.name}
      }
    )
  rescue
  end
  end
end
