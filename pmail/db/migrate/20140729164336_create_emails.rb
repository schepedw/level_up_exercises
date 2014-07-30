class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.boolean :checked
      t.boolean :starred
      t.string :sender
      t.string :subject
      t.timestamp :send_date
      t.string :recipient
      t.text :body
    end
  end
end
