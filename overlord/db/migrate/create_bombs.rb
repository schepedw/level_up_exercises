class Create_Bombs < ActiveREcord::Migration
  def self.up
    create_table :bombs do |t|
      t.string :activation_code
      t.string :deactivation_code
    end
  end

  def self.down
    drop_table :bombs
  end
end
