class CreateLogEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :log_entries do |t|
      t.string :date
      t.integer :delay
      t.string :number

      t.timestamps
    end
  end
end
