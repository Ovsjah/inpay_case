class CreatePaymentRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_requests do |t|
      t.string :full_name
      t.float :amount
      t.string :currency
      t.string :iban
      t.string :status, default: :pending

      t.timestamps
    end
  end
end
