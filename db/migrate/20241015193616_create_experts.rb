class CreateExperts < ActiveRecord::Migration[7.2]
  def change
    create_table :experts do |t|
      t.string :salutation
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :nationality
      t.string :phone_number
      t.string :email
      t.string :location
      t.string :communication_language
      t.string :teaching_language
      t.integer :hourly_rate
      t.integer :daily_rate
      t.string :travel_willingness
      t.string :availability
      t.text :china_experience
      t.string :specialty
      t.text :specalties_details
      t.string :institution
      t.text :cooperation_opportunity
      t.text :remarks

      t.timestamps
    end
  end
end
