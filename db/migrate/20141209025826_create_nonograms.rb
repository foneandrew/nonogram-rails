class CreateNonograms < ActiveRecord::Migration
  def change
    create_table :nonograms do |t|

      t.timestamps
    end
  end
end
