class CreateNonograms < ActiveRecord::Migration
  def change
    create_table :nonograms do |t|
      t.text    :name,      null: false
      t.text    :hint,      null: false
      t.text    :solution,  null: false
      t.integer :size,      null: false
      t.timestamps
    end
  end
end
