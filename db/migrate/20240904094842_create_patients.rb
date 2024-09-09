class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :contact_details
      t.text :history_summary

      t.timestamps
    end
  end
end
