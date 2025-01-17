module ApplicationHelper
  def switch_direction(direction)
    direction == "asc" ? "desc" : "asc"
  end
end
