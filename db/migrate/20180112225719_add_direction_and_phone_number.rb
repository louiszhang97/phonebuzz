class AddDirectionAndPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    add_column :log_entries, :phone_num, :string
    add_column :log_entries, :direction, :string 
  end
end
