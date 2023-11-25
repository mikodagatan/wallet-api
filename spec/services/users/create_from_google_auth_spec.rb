require 'rails_helper'

RSpec.describe Users::CreateFromGoogleAuth, type: :service do
  describe '#call' do
    expect(described_class.new({}).call).to eq(1)
  end
end
