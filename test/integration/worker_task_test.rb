require "test_helper"

class WorkerTaskTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create :manager
    @worker = create :worker
    @another_worker = create :worker
  end

  test "lists tasks" do
    create :task, assignee: @worker
    create :task, assignee: @worker
    create :task

    get "/worker/tasks?auth_user_id=#{@worker.id}"
    assert_response :success

    json_response = JSON.parse(@response.body)

    assert_equal 2, json_response.count
  end

  test "updates task" do
    task = create :task, comment: "some comment", assignee: @worker
    params = {comment: "some other comment"}
    patch "/worker/tasks/#{task.id}?auth_user_id=#{@worker.id}", params: params, as: :json
    assert_response :success

    tasks = displayed_tasks

    assert_equal 1, tasks.count
    assert_equal "some other comment", tasks[0]["comment"]
  end

  ### Now to authorization

  test "does not update another's task" do
    task = create :task, comment: "some comment", assignee: @another_worker
    params = {comment: "some other comment"}
    patch "/worker/tasks/#{task.id}?auth_user_id=#{@worker.id}", params: params, as: :json
    assert_response 401
  end

  test "manager can not update task as worker" do
    task = create :task, comment: "some comment", assignee: @worker, managed_by: [@manager.id]
    params = {comment: "some other comment"}
    patch "/worker/tasks/#{task.id}?auth_user_id=#{@manager.id}", params: params, as: :json
    assert_response 401
  end

  private

  def displayed_tasks
    get "/worker/tasks?auth_user_id=#{@worker.id}"
    assert_response :success

    json_response = JSON.parse(@response.body)
  end
end
