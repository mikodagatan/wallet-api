RSpec.shared_examples 'HasPagination' do
  let(:dummy_class) do
    Class.new do
      include HasPagination
      attr_accessor :params

      def initialize(params)
        @params = params
      end
    end
  end

  describe '#paginate' do
    it 'returns paginated relation' do
      relation = double('Relation')
      instance = dummy_class.new(page: 2, per_page: 10)

      expect(relation).to receive(:page).with(2).and_return(relation)
      expect(relation).to receive(:per).with(10)

      instance.paginate(relation)
    end
  end

  describe '#page' do
    it 'returns the specified page or default' do
      instance = dummy_class.new(page: 3)

      expect(instance.page).to eq(3)
    end

    it 'returns the default page if not specified' do
      instance = dummy_class.new({})

      expect(instance.page).to eq(1)
    end
  end

  describe '#per_page' do
    it 'returns the specified per_page or default' do
      instance = dummy_class.new(per_page: 50)

      expect(instance.per_page).to eq(50)
    end

    it 'returns the default per_page if not specified' do
      instance = dummy_class.new({})

      expect(instance.per_page).to eq(25)
    end
  end
end
