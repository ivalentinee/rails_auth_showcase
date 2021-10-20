class Worker::TasksController < ApplicationController
  def list
    tasks = ::Services::Worker::Tasks.list(@current_user)

    authorize(nil, :list?, policy_class: ::Policies::WorkerTaskPolicy)

    render json: tasks
  end

  def update
    task = ::Services::Tasks.get(params["id"])

    authorize(task, :update?, policy_class: ::Policies::WorkerTaskPolicy)

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
