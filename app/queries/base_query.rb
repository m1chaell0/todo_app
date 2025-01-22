class BaseQuery
  include Pagy::Backend

  attr_reader :records, :params

  def initialize(records, params = {})
    @records = records
    @params = params
  end

  def call
    @call ||= begin
                   apply_filtering
                   apply_search
                   apply_sorting
                   paginated
                 end
  end

  private

  def paginated
    pagy(records, page: params[:page] || 1, limit: params[:per_page] || 10)
  end
end
