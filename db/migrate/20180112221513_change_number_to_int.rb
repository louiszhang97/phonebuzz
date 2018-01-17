class ChangeNumberToInt < ActiveRecord::Migration[5.1]
  def up
    change_column :log_entries, :number, 'integer USING CAST(number AS integer)', :default => 0
  end

  def down
    change_column :log_entries, :number, :string, :default => '0'
  end
end
