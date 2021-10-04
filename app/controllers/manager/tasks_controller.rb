class Manager::TasksController < ApplicationController
  def list
    tasks = ::Services::Manager::Tasks.list()
    render json: tasks
  end

  def create
    if ::Services::Manager::Tasks.create(task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def update
    if ::Services::Manager::Tasks.update(params["id"], task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def delete
    ::Services::Manager::Tasks.delete(params["id"])
    render text: "ok"
  end

  def assign
    ::Services::Manager::Tasks.assign(params["worker_id"], params["task_ids"])
    render text: "ok"
  end

  def merge
    ::Services::Manager::Tasks.merge(params["ids"])
    render text: "ok"
  end

  private

  def task_params
    params.permit(:description)
  end
end
