RSpec.shared_examples 'HasWallet' do
  describe 'associations' do
    it { is_expected.to have_one(:wallet).dependent(:destroy).inverse_of(:entity) }
  end

  describe 'callbacks' do
    it 'triggers create_wallet callback after create' do
      entity = build(described_class.name.underscore.to_sym)
      entity.save

      expect(entity.wallet).to be_present
    end
  end
end
