class Things < ActiveRecord::Migration
  def self.up
    create_table :bombs do |t|
      t.string :activation_code
      t.string :deactivation_code
      t.string :status
    end
  end

  def self.down
    drop_table :bombs
  end
end
