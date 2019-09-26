json.set! :data do
  json.array! @groups do |group|
    json.partial! 'groups/group', group: group
    json.url  "
              #{link_to 'Show', group }
              #{link_to 'Edit', edit_group_path(group)}
              #{link_to 'Destroy', group, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end