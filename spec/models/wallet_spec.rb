require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { should belong_to(:entity) }
    it { should have_many(:credit_transactions).class_name('Transaction').with_foreign_key('source_wallet_id') }
    it { should have_many(:debit_transactions).class_name('Transaction').with_foreign_key('target_wallet_id') }
  end

  describe 'methods' do
    describe '#all_transactions' do
      let(:wallet) { create(:wallet) }

      it 'returns all transactions related to the wallet' do
        transaction1 = create(:deposit_transaction, target_wallet: wallet)
        transaction2 = create(:withdrawal_transaction, source_wallet: wallet)

        expect(wallet.all_transactions).to include(transaction1, transaction2)
      end
    end

    describe '#update_balance' do
      let!(:wallet) { create(:wallet) }

      it 'updates the balance based on credit and debit transactions' do
        create(:deposit_transaction, target_wallet: wallet, amount: 30)
        create(:deposit_transaction, target_wallet: wallet, amount: 10)
        create(:withdrawal_transaction, source_wallet: wallet, amount: 20)

        wallet.update_balance

        expect(wallet.balance).to eq(30 + 10 - 20)
      end
    end
  end
end
