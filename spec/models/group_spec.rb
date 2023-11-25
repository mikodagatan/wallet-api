require 'rails_helper'

RSpec.describe Group, type: :model do
  it_behaves_like 'HasWallet'

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
