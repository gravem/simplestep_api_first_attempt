class CreateSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :steps do |t|
      t.references :checklist_template, null: false, foreign_key: true
      t.text :description
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
