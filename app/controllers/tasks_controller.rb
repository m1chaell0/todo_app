class TasksController < ApplicationController
  def index
    @tasks = params[:display_expired] ? current_user.tasks : current_user.tasks.active
    apply_filtering if params[:q]
    apply_sorting
  end

  def new
    @task = Task.new
    set_categories
  end

  def create
    @task = Tasks::Create.create(task_params)
    set_categories
    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_task
  end

  def edit
    set_task
    set_categories
  end

  def update
    set_task
    form = ActiveType.cast(@task, Tasks::Update)
    if form.update(task_params)
      redirect_to tasks_path
    else
      set_categories
      @task = form
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_task
    form = ActiveType.cast(@task, Tasks::Destroy)
    form.current_user = current_user
    if form.destroy(@task)
      redirect_to tasks_path
    else
      @task = form
      render :show, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :scheduled_for, :category_id)
          .merge(user_id: current_user.id)
  end

  def set_categories
    @categories = current_user.categories_for_select
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def apply_sorting
    # Ensure the column is valid to avoid SQL injection.
    # We'll limit to known columns for demonstration:
    valid_sort_columns = ["title", "scheduled_for", "category", "updated_at"]
    sort_column = valid_sort_columns.include?(params[:sort]) ? params[:sort] : "scheduled_for"

    # direction: asc or desc
    sort_direction = (params[:direction] == "desc") ? "desc" : "asc"

    if params[:sort] == "category"
      @tasks = @tasks.joins(:category).order("categories.name #{sort_direction}")
    else
      @tasks = @tasks.order("#{sort_column} #{sort_direction}")
    end
  end

  def apply_filtering
    search_term = "%#{params[:q]}%"
    @tasks = @tasks.joins(:category).where(
      "tasks.title ILIKE :search
         OR tasks.description ILIKE :search
         OR categories.name ILIKE :search",
      search: search_term
    )
  end
end
