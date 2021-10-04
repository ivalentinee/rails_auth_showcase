require "test_helper"

class ManagerTaskTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create :manager
  end

  test "lists tasks" do
    create :task, managed_by: [@manager.id]
    create :task

    get "/manager/tasks?auth_user_id=#{@manager.id}"
    assert_response :success

    json_response = JSON.parse(@response.body)

    assert_equal 2, json_response.count
  end

  test "creates task" do
    params = {description: "some description"}
    post "/manager/tasks?auth_user_id=#{@manager.id}", params: params, as: :json
    assert_response :success

    tasks = displayed_tasks

    assert_equal 1, tasks.count
    assert_equal "some description", tasks[0]["description"]
  end

  test "updates task" do
    task = create :task, managed_by: [@manager.id], description: "some description"
    params = {description: "some other description"}
    patch "/manager/tasks/#{task.id}?auth_user_id=#{@manager.id}", params: params, as: :json
    assert_response :success

    tasks = displayed_tasks

    assert_equal 1, tasks.count
    assert_equal "some other description", tasks[0]["description"]
  end

  test "deletes task" do
    task = create :task, managed_by: [@manager.id]

    delete "/manager/tasks/#{task.id}?auth_user_id=#{@manager.id}"
    assert_response :success

    tasks = displayed_tasks

    assert_equal 0, tasks.count
  end

  test "assignes tasks" do
    task_1 = create :task, managed_by: [@manager.id], description: "111"
    task_2 = create :task, managed_by: [@manager.id], description: "222"
    worker = create :worker, managed_by: [@manager.id]

    params = {"worker_id" => worker.id, "task_ids" => [task_1.id, task_2.id]}
    post "/manager/tasks/assign?auth_user_id=#{@manager.id}", params: params
    assert_response :success

    tasks = displayed_tasks

    assert_equal worker.id, tasks[0]["assignee_id"]
    assert_equal worker.id, tasks[1]["assignee_id"]
  end

  test "merges tasks" do
    task_1 = create :task, managed_by: [@manager.id], description: "111"
    task_2 = create :task, managed_by: [@manager.id], description: "222"

    post "/manager/tasks/merge?auth_user_id=#{@manager.id}", params: {"ids" => [task_1.id, task_2.id]}
    assert_response :success

    tasks = displayed_tasks

    assert_equal 1, tasks.count
    expected_description = task_1.description + "\n" + task_2.description
    assert_equal expected_description, tasks[0]["description"]
  end

  private

  def displayed_tasks
    get "/manager/tasks?auth_user_id=#{@manager.id}"
    assert_response :success

    json_response = JSON.parse(@response.body)
  end
end
