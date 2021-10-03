require "test_helper"

class WorkerTaskTest < ActionDispatch::IntegrationTest
  setup do
    @worker = create :worker
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

  private

  def displayed_tasks
    get "/worker/tasks?auth_user_id=#{@worker.id}"
    assert_response :success

    json_response = JSON.parse(@response.body)
  end
end
