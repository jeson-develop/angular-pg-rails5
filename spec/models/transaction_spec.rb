require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:bank_account)    { create :bank_account }
  let(:credior_account) { create :credior_account }
  let(:transaction) { create :transaction, bank_account: bank_account }

  subject { transaction }

  describe "scopes" do
    it { expect(transaction).to be_a Transaction }
    it { should belong_to(:bank_account) }
    it { should belong_to(:creditor) }
    it { should validate_presence_of(:bank_account_id) }
  end

  describe '#state_to_s' do
    before { create :transaction, :d, bank_account: bank_account }
    
    context 'for withdraw' do
      let(:transaction) { create :transaction, :w, bank_account: bank_account, creditor: nil }
      its(:state_to_s) { is_expected.to eq 'Withdraw' }
    end
    context 'for deposit' do
      let(:transaction) { create :transaction, :d, bank_account: bank_account, creditor: nil }
      its(:state_to_s) { is_expected.to eq 'Deposit' }
    end
    context 'for credit' do
      let(:transaction1) { create :transaction, :d, bank_account: bank_account, creditor: credior_account }
      let(:transaction2) { create :transaction, :w, bank_account: bank_account, creditor: credior_account }
      it { expect(transaction1.state_to_s).to include 'Transfer by' }
      it { expect(transaction2.state_to_s).to include 'Transfer to' }
    end
  end
end
