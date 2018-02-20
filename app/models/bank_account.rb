class BankAccount < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_many :transactions

  def balance
    (transactions.where(state: 0).sum(:amount)) - transactions.where(state: 1).sum(:amount)
  end

  # 0 :deposit, 1: withdraw, 2: credit
  def transaction(st, amount, creditor_account = nil)
    if st == 0
      deposit(amount, creditor_account)
    elsif st == 1
      withdraw(amount, creditor_account)
    elsif st == 2
      self.credit(amount, creditor_account)
    end
    errors.blank?
  end

  def deposit(amount, creditor_account = nil)
    t = transactions.new(amount: amount, state: 0, creditor: creditor_account)
    unless (t.save)
      errors.add(:base, t.errors.full_messages)
    end
    t
  end

  def withdraw(amount, creditor_account = nil)
    t = transactions.new(amount: amount, state: 1, creditor: creditor_account)
    unless (t.save)
      errors.add(:base, t.errors.full_messages)
    end
    t
  end

  def credit(amount, creditor_account)
    BankAccount.transaction do
      if creditor_account.blank?
        errors.add(:base, 'Please select username')
        raise ActiveRecord::Rollback
      end
      unless t1 = transaction(1, amount, creditor_account)
        errors.add(:base, 'Invalid amount')
        raise ActiveRecord::Rollback
      else
        t2 = creditor_account.transaction(0, amount, self)
      end
    end
    self
  end
end
