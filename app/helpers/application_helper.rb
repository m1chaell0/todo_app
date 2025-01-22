module ApplicationHelper
  include Pagy::Frontend

  def switch_direction(direction)
    direction == "asc" ? "desc" : "asc"
  end
end
