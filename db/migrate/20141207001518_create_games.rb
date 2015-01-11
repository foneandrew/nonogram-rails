class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime  :time_started
      t.datetime  :time_finished
      t.integer   :nonogram_id
      t.index     :nonogram_id
      t.integer   :user_id, null: false
      t.index     :user_id
      t.timestamps
    end
  end
end
