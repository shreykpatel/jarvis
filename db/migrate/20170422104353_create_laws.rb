class CreateLaws < ActiveRecord::Migration[5.0]
  def change
  	create_table :laws do |t|
      t.string :genre
      t.string :location
      t.string :offense
      t.string :description
      t.string :fine_first_offense
      t.string :prison_first_offense
      t.string :fine_second_offense
      t.string :prison_second_offense
      t.string :additional_information
      t.string :intents
    end
  end
end
