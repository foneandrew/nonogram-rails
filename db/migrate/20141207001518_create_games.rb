class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime  :time_started
      t.datetime  :time_finished
      t.integer   :nonogram_id
      t.timestamps
    end
  end
end
