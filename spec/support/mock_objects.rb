class MockController
end

class Mock
  attr_accessor :name

  def initialize(name = 'name')
    @name = name
  end
end

class MockSerializer < Blueprinter::Base
  fields :name
end
