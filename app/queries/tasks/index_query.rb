class Tasks::IndexQuery < BaseQuery
  def initialize(records, params = {})
    @params = params
    @records = params[:display_expired] ? records : records.active
  end

  private

  attr_reader :records, :params

  def apply_filtering
    if params[:status].present?
      @records = @records.by_status(params[:status])
    end
  end

  def apply_search
    search_term = "%#{params[:q]}%"
    @records = @records.joins(:category).where(
      "tasks.title ILIKE :search
       OR tasks.description ILIKE :search
       OR categories.name ILIKE :search",
      search: search_term
    )
  end

  def apply_sorting
    sort_column = %w[title start_time category updated_at].include?(params[:sort]) ? params[:sort] : "start_time"
    sort_direction = (params[:direction] == "desc") ? "desc" : "asc"

    if params[:sort] == "category"
      @records = @records.joins(:category).order("categories.name #{sort_direction}")
    else
      @records = @records.order("#{sort_column} #{sort_direction}")
    end
  end
end
