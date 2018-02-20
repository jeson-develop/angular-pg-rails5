require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:bank_account)    { create :bank_account }
  let(:credior_account) { create :credior_account }

  subject { bank_account }

  describe "scopes" do
    it { expect(bank_account).to be_a BankAccount }
    it { should have_many(:transactions) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "#transaction" do
    it { expect(subject.transaction(0, 100)).to be true }
    it { expect(subject.transaction(1, 100)).to be false }
    it { expect(subject.transaction(2, 100)).to be false }

    context 'with balance' do
      before { subject.transaction(0, 100) }

      it { expect(subject.transaction(1, 10)).to be true }
      it { expect(subject.transaction(2, 10, credior_account)).to be true }
    end  
  end

  describe "#deposit" do
    it { expect(subject.deposit(100).amount).to eq 100 }
    it { expect(subject.deposit('Test').amount).to eq 0 }
  end

  describe "#withdraw" do
    it { expect(subject.withdraw(100).errors.messages[:base]).to include "You don't have enough balance to withdraw $100.0" }
    it { expect(subject.withdraw('Test').amount).to eq 0 }

    context 'with balance' do
      before { subject.transaction(0, 100) }

      it { expect(subject.withdraw(10).amount).to eq 10 }
      it { expect(subject.withdraw(10, credior_account).amount).to eq 10 }
      it { expect(subject.withdraw(10, credior_account).creditor).to eq credior_account }
    end
  end

  describe "#credit" do
    it { expect(subject.credit(100, credior_account).errors.messages[:base].join(',')).to include "You don't have enough balance to withdraw $100.0" }
    it { expect(subject.credit('Test', credior_account).errors.messages[:base].join(',')).to include 'Please enter non-zero amount', 'Invalid amount' }

    context 'with balance 100' do
      before { subject.transaction(0, 100) }

      it 'credit 10' do
        subject.credit(10, credior_account)
        expect(subject.balance).to eq 90
        expect(credior_account.balance).to eq 10
      end

      it 'credit 101' do
        expect(subject.credit(101, credior_account).errors.messages[:base].join(',')).to include "You don't have enough balance to withdraw $101.0"
      end
    end
  end
end
