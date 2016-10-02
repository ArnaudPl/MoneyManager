class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.boolean :type
      t.float :amount
      t.string :label
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
