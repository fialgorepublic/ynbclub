class AddColumnInviteeToPoints < ActiveRecord::Migration[5.1]
  def change
    add_column :points, :invitee, :string
  end
end
