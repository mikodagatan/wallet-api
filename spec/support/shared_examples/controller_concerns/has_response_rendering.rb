RSpec.shared_examples 'HasResponseRendering' do
  let(:instance) { described_class.new }

  describe '#render_collection' do
    it 'renders the collection with pagination and serialization' do
      collection = Mock.new
      allow(instance).to receive(:serialize_hash).and_return({ name: 'Sample Name' })
      allow(instance).to receive(:page).and_return(1)
      allow(instance).to receive(:per_page).and_return(25)

      result = instance.render_collection(collection)

      # NOTE: cannot replicate actual scenario.
      # Will need collection to be an Active Record Relation.

      expect(result).to eq({
                             mocks: { name: 'Sample Name' },
                             page: 1,
                             per_page: 25
                           })
    end
  end

  describe '#render_record' do
    it 'renders the record with serialization' do
      record = Mock.new('Sample Name')
      allow(instance).to receive(:serialize_hash).and_return({ name: 'Sample Name' })

      result = instance.render_record(record)

      expect(result).to eq({
                             mock: { name: 'Sample Name' }
                           })
    end
  end
end
