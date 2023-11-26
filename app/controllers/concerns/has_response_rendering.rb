module HasResponseRendering
  extend ActiveSupport::Concern

  include HasPagination
  include HasSerialization

  def render_collection(collection)
    key = collection.class.to_s.split('::').first
                    .underscore.pluralize

    { key.to_sym => serialize_hash(collection) }.merge(page:, per_page:)
  end

  def render_record(record)
    key = record.class.to_s.underscore

    { key.to_sym => serialize_hash(record) }
  end
end
