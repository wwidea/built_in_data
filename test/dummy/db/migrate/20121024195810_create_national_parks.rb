class CreateNationalParks < ActiveRecord::Migration
  def change
    create_table :national_parks do |t|
      t.string :name
      t.date :established
      t.string :url

      t.timestamps
    end
  end
end
