require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it_behaves_like 'TransactionValidations'

  describe 'associations' do
    it { should belong_to(:source_wallet).class_name('Wallet').optional(true) }
    it { should belong_to(:target_wallet).class_name('Wallet').optional(true) }
  end

  describe 'enums' do
    it { should define_enum_for(:transaction_type).with_values(%i[withdrawal deposit transfer]) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'methods' do
    describe '#update_wallet_balances' do
      let!(:source_wallet) { create(:wallet) }
      let!(:target_wallet) { create(:wallet) }
      let!(:previous_transaction_source) do
        create(:transaction, target_wallet: source_wallet, amount: 100, transaction_type: :deposit)
      end
      let!(:previous_transaction_target) do
        create(:transaction, target_wallet:, amount: 50, transaction_type: :deposit)
      end

      it 'updates source and target wallet balances after create' do
        create(:transaction, source_wallet:, target_wallet:, amount: 30)

        expect(source_wallet.reload.balance).to eq(100 - 30)
        expect(target_wallet.reload.balance).to eq(50 + 30)
      end
    end

    describe '#assign_transaction_type' do
      let(:transaction) { build(:transaction, source_wallet: nil, target_wallet: nil) }

      it 'assigns :withdrawal transaction type when source wallet is present' do
        transaction.source_wallet = create(:wallet)
        transaction.send(:assign_transaction_type)
        expect(transaction.withdrawal?).to be true
      end

      it 'assigns :deposit transaction type when target wallet is present' do
        transaction.target_wallet = create(:wallet)
        transaction.send(:assign_transaction_type)
        expect(transaction.deposit?).to be true
      end

      it 'assigns :transfer transaction type when both source and target wallets are present' do
        transaction.source_wallet = create(:wallet)
        transaction.target_wallet = create(:wallet)
        transaction.send(:assign_transaction_type)
        expect(transaction.transfer?).to be true
      end
    end
  end
end
