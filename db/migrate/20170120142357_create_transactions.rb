class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.references 	:bank_account
      t.float 		:amount, default: 0
      t.integer 	:state, default: 0
      t.integer 	:creditor_id

      t.timestamps
    end
  end
end
