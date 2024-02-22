class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :verified
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :title
      t.string :role
      t.integer :score

      t.timestamps
    end
  end
end
