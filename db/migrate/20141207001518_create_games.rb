class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime  :time_started
      t.datetime  :time_finished
      t.text      :solution
      t.integer   :size
      t.timestamps
    end
  end
end
