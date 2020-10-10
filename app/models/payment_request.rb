class PaymentRequest < ApplicationRecord
  validates_presence_of :full_name
  validates :amount, numericality: true
  validates_inclusion_of :currency, in: %w(USD EUR GBP), message: "must be in USD, EUR or GBP!"
  validates_with IbanValidator
end
