class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :confirm_password
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
