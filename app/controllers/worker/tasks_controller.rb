class Worker::TasksController < ApplicationController
  def list
    tasks = ::Services::Worker::Tasks.list(@current_user)
    render json: tasks
  end

  def update
    task = ::Services::Tasks.get(params["id"])
    Authorization.authorize!([:worker, :task_update], @current_user, task)

    if ::Services::Worker::Tasks.update(task, task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  private

  def task_params
    params.permit(:comment)
  end
end
