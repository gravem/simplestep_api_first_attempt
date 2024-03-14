class AddUserToChecklistTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :checklist_templates, :user, null: false, foreign_key: true
  end
end
