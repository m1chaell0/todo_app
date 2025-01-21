require 'rails_helper'

describe TasksController, type: :controller do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }
  let(:user_category1) { create(:category, user: user) }
  let(:user_category2) { create(:category, user: user) }
  let(:common_category3) { create(:category) }
  let(:tasks) do
    create_mixed_tasks(user: user, count: 30)
    end

  context "when signed_id" do
    before do
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    describe "GET #index" do
      context "without params" do
        it "returns all user's future tasks with default sorting" do
          get :index
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:index)
          expect(assigns(:tasks)).to eq(user.tasks.active.order(start_time: :asc))
        end
      end

      context "with sorting params" do
        it "returns sorted tasks by title in descending order" do
          get :index, params: { sort: "title", direction: "desc" }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:index)
          expect(assigns(:tasks)).to eq(user.tasks.active.order(title: :desc))
        end
      end

      context "with display_expired param" do
        it "returns all tasks including expired ones" do
          get :index, params: { display_expired: "1" }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:index)
          expect(assigns(:tasks)).to eq(user.tasks.order(start_time: :asc))
        end
      end

      context "with q param" do
        let(:sample_task) { create(:task, :pending, user: user, category: user_category1, description: "Sample description") }
        let(:q) { "description" }
        it "returns filtered tasks" do
          get :index, params: { q: q }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:index)
          expect(assigns(:tasks)).to eq(user.tasks.active.where("title ILIKE ?", "%#{q}%"))
        end
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        let(:valid_attributes) { attributes_for(:task, category_id: user_category1.id, start_time: 5.days.from_now) }

        it "creates a new task and redirects to index" do
          expect {
            post :create, params: { task: valid_attributes }
          }.to change(Task, :count).by(1)

          expect(response).to redirect_to(tasks_path)
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) { attributes_for(:task, category_id: common_category3.id, title: nil,
                                                  start_time: 1.week.ago) }

        it "does not create a task and re-renders the new template" do
          expect {
            post :create, params: { task: invalid_attributes }
          }.not_to change(Task, :count)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET #edit" do
      let(:task) { create(:task, :pending, user: user, category: user_category1) }

      it "renders the edit template" do
        get :edit, params: { id: task.id }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(assigns(:task)).to eq(task)
        expect(assigns(:categories)).to eq(user.categories_for_select)
      end
    end

    describe "PATCH #update" do
      let(:task) { create(:task, :pending, user: user, category: user_category1) }

      context "with valid attributes" do
        let(:new_attributes) { { title: "Updated Title" } }

        it "updates the task and redirects to index" do
          patch :update, params: { id: task.id, task: new_attributes }
          expect(response).to redirect_to(tasks_path)
          expect(task.reload.title).to eq("Updated Title")
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) { { title: nil } }

        it "does not update the task and re-renders the edit template" do
          patch :update, params: { id: task.id, task: invalid_attributes }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(task.reload.title).not_to eq(nil)
        end
      end

      describe "DELETE #destroy" do
        let(:task) { create(:task, :pending, user: user, category: user_category1) }

        before do
          task
        end

        it "deletes the task and redirects to index" do
          expect {
            delete :destroy, params: { id: task.id }
          }.to change(Task, :count).by(-1)

          expect(response).to redirect_to(tasks_path)
        end
      end

      describe "GET #show" do
        let(:task) { create(:task, user: user, category: user_category1, start_time: 5.hours.from_now) }

        it "renders the show template" do
          get :show, params: { id: task.id }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:show)
          expect(assigns(:task)).to eq(task)
        end
      end
    end
  end

  it_behaves_like "unauthorized_request", :get, :index
end


def create_mixed_tasks(user:, count:)
  Array.new(count) do
    case rand(4)
    when 0
      # Pending => start_time in the future, no completed_at
      create(:task,
             user: user,
             category: [ user_category1, user_category2, common_category3 ].sample,
             start_time: rand(1..5).days.from_now,
             end_time: (rand(6..10).days.from_now if [ true, false ].sample), # randomly nil or set
             completed_at: nil
      )
    when 1
      # Overdue => start_time in the past, not completed
      # If end_time is present, ensure it's also in the past so it’s truly overdue
      start_t = rand(2..5).days.ago
      create(:task,
             user: user,
             category: [ user_category1, user_category2, common_category3 ].sample,
             start_time: start_t,
             end_time: (start_t + 1.day if [ true, false ].sample), # about 1 day after start
             completed_at: nil
      )
    when 2
      # Completed => random start_time, completed_at set to sometime AFTER start_time
      start_t = rand(1..7).days.ago
      create(:task,
             user: user,
             category: [ user_category1, user_category2, common_category3 ].sample,
             start_time: start_t,
             end_time: (start_t + rand(1..3).days if [ true, false ].sample),
             completed_at: start_t + rand(1..3).days # ensure it’s after start_t
      )
    else
      # Overdue but eventually completed => start_time in the past, completed_at AFTER it was overdue
      start_t = (5..10).to_a.sample.days.ago
      end_t   = start_t + rand(1..2).days
      create(:task,
             user: user,
             category: [ user_category1, user_category2, common_category3 ].sample,
             start_time: start_t,
             end_time: end_t,
             completed_at: end_t + rand(1..2).days # completed after end_time
      )
    end
  end
end
