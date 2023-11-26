module HasSerialization
  extend ActiveSupport::Concern

  def serialize_base(collection)
    key = collection.class.to_s.split('::').first

    "#{key}Serializer".constantize
  end

  def serialize_hash(collection)
    serialize_base(collection).render_as_hash(collection)
  end

  def serialize(collection)
    serialize_base(collection).render(collection)
  end
end
