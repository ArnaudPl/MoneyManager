class RenameTypeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :transactions, :type, :withdraw
  end
end
