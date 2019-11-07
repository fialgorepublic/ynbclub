json.set! :data do
  json.array! @conversations do |conversation|
    json.partial! 'conversations/conversation', conversation: conversation
    json.url  "
              #{link_to 'Show', conversation }
              #{link_to 'Edit', edit_conversation_path(conversation)}
              #{link_to 'Destroy', conversation, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end