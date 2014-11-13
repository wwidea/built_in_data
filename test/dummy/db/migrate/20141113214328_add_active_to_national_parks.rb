class AddActiveToNationalParks < ActiveRecord::Migration
  def change
    add_column :national_parks, :active, :boolean
  end
end
