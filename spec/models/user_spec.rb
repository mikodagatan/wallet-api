require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:wallet).dependent(:destroy).inverse_of(:entity) }
    it { should have_many(:debit_transactions).through(:wallet) }
    it { should have_many(:credit_transactions).through(:wallet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'delegations' do
    it { should delegate_method(:all_transactions).to(:wallet) }
  end
end
