class Worker::TasksController < ApplicationController
  def list
    tasks = ::Services::Worker::Tasks.list(@current_user)
    render json: tasks
  end

  def update
    if ::Services::Worker::Tasks.update(params["id"], task_params)
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
