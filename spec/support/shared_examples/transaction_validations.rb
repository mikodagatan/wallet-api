RSpec.shared_examples 'TransactionValidations' do
  subject { described_class.new }

  let(:source_wallet) { create(:wallet) }
  let(:target_wallet) { create(:wallet) }

  before do
    subject.amount = 10
    create(:deposit_transaction, target_wallet:)
    create(:deposit_transaction, target_wallet: source_wallet)
  end

  describe '#source_or_target_wallet_presence' do
    context 'when neither source nor target wallet is present' do
      it 'is invalid' do
        subject.valid?
        expect(subject.errors[:base]).to include('Either source_wallet_id or target_wallet_id must be present')
      end
    end

    context 'when source wallet is present' do
      before { subject.source_wallet = source_wallet }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when target wallet is present' do
      before { subject.target_wallet = target_wallet }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe '#source_wallet_balance_not_below_zero' do
    context 'when source wallet balance is above 0' do
      before { subject.source_wallet = source_wallet }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when source wallet balance is below 0' do
      before do
        subject.source_wallet = source_wallet
        subject.amount = 200
      end

      it 'is invalid' do
        subject.valid?
        expect(subject.errors[:base]).to include('Source wallet balance cannot go below 0')
      end
    end
  end

  describe '#duplicate_transaction_within_1_minute' do
    let(:params) do
      {
        source_wallet:,
        target_wallet:,
        amount: 20
      }
    end

    context 'when an existing transaction exists within 1 minute' do
      let!(:existing_transaction) { create(:transaction, params) }

      it 'is invalid' do
        transaction = build(:transaction, params)
        transaction.save

        expect(transaction.errors[:base]).to include('Cannot create duplicate transaction within 1 minute')
      end
    end

    context 'when no existing transaction exists outside 1 minute' do
      let(:new_params) { params.merge!(created_at: 2.minutes.ago) }

      let!(:existing_transaction) { create(:transaction, new_params) }

      it 'is valid' do
        transaction = build(:transaction, params)

        expect(transaction).to be_valid
      end
    end
  end
end
