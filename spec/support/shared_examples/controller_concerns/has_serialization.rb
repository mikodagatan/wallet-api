RSpec.shared_examples 'HasSerialization' do
  let(:instance) { described_class.new }

  describe '#serialize_base' do
    it 'returns the correct serializer class' do
      expect(instance.serialize_base(Mock.new)).to eq(MockSerializer)
    end
  end

  describe '#serialize_hash' do
    it 'returns the hash representation of the collection' do
      expect(instance.serialize_hash(Mock.new('Sample Name'))).to eq({ name: 'Sample Name' })
    end
  end

  describe '#serialize' do
    it 'returns the serialized representation of the collection' do
      expect(instance.serialize(Mock.new('Sample Name'))).to eq({ name: 'Sample Name' }.to_json)
    end
  end
end
