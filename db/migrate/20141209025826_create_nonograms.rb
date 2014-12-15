class CreateNonograms < ActiveRecord::Migration
  def change
    create_table :nonograms do |t|
      t.text    :solution,  null: false
      t.integer :size,      null: false
      t.timestamps
    end
  end
end
