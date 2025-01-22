# TodoApp

TodoApp is a full-stack web application designed for task management and planning. It demonstrates the implementation of a modern web application with comprehensive backend and frontend functionality.

## Features

- **View Tasks**: View a list of to-do items with filtering options:
    - Pending tasks
    - Overdue tasks
    - In progress tasks
    - Completed tasks
    - All tasks
- **Task Management**:
    - Create new to-do items
    - Edit existing to-do items
    - Delete to-do items
    - Mark tasks as completed
- **Actualize own profile data**: Update your own profile data, such as name, email, and password.
- **Custom Categories**: Organize tasks into user-defined categories.
- **Sorting and Filtering**: Sort and filter tasks by title, start time, category, and more.
- **Pagination**: Efficiently paginate large lists of tasks.

## Technology Stack

- **Backend**: Ruby on Rails 8.0.1
- **Frontend**:
    - Turbo
    - Propshaft
    - Sass
- **Database**: PostgreSQL
- **Language**: Ruby 3.3.1

## Task Scopes

### Active
- Includes all tasks that are not yet completed.


### Overdue
- Includes tasks where:
    - `start_time` is in the past, and `end_time` is `NULL`.
    - Or both `start_time` and `end_time` are in the past.

### In Progress
- Tasks where the current time is between `start_time` and `end_time`.

### Pending
- Tasks with `start_time` in the future.


## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/m1chaell0/todo_app.git
   cd todo_app
   ```

2. **Install Dependencies**:
   ```bash
   bundle install
   ```

3. **Configure the Database**:
  - Edit the `config/database.yml` file to match your local database configuration.

4. **Setup the Database**:
   ```bash
   rails db:create db:migrate db:seed
   ```

5. **Run the Application**:
   ```bash
   rails server
   ```
   To apply your changes to the scss files, run the following command:
   ```bash
   rails dartsass:build
   ```
   

6. **Access the App**:
   Open your browser and navigate to `http://localhost:3000`.

## Testing

The app uses RSpec for testing. To run the test suite:

```bash
bundle exec rspec
```

## Future Plans

- **SMS/Email Notifications**: Add reminders and notifications via SMS and/or email.
- **Email Verification**: Ensure users verify their email addresses during sign-up.

## License

This project is open-source and available under the MIT License.

---

For any issues or contributions, feel free to create an issue or submit a pull request.

