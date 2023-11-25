require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    it { should have_one(:wallet).dependent(:destroy).inverse_of(:wallet).class_name('Wallet') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
