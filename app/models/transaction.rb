class Transaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :creditor, class_name: 'BankAccount', foreign_key: :creditor_id, required: false

  validates :bank_account_id, presence: true
  validate :valid_amount

  enum state: [:deposit, :withdraw]

  def amount_status
    state == 'withdraw' ? 'DR' : 'CR'
  end

  def state_to_s
    msg = state
    if creditor.present?
      msg = "#{state == 'withdraw' ? 'transfer to' : 'transfer by'} `#{creditor.username}`"
    end
    "#{msg}".capitalize
  end

  def success_message
    if creditor.present?
      "#{bank_account.username} has transfered $#{amount.round(2)} to #{creditor.username}'s account"
    else
      if state == 'withdraw'
        "#{bank_account.username} has withdraw $#{amount.round(2)}"
      else
        "$#{amount.round(2)} is deposited to #{bank_account.username}'s account"
      end
    end
  end

  private
  def valid_amount
    if amount <= 0
      errors.add(:base, 'Please enter non-zero amount')
    end
    if state == 'withdraw' && (bank_account.balance < amount)
      errors.add(:base, "You don't have enough balance to withdraw $#{amount}")
    end
  end
end
