module HasPagination
  extend ActiveSupport::Concern

  def paginate(relation)
    relation.page(page).per(per_page)
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 25
  end
end
