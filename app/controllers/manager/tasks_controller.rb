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
    task = ::Services::Tasks.get(params["id"])
    Authorization.authorize!([:manager, :task_update], @current_user, task)

    if ::Services::Manager::Tasks.update(task, task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def delete
    task = ::Services::Tasks.get(params["id"])
    Authorization.authorize!([:manager, :task_delete], @current_user, task)

    ::Services::Manager::Tasks.delete(task)
    render text: "ok"
  end

  def assign
    tasks = ::Services::Tasks.get(params["task_ids"])
    worker = ::Services::Users.get(params["worker_id"])
    Authorization.authorize!([:manager, :task_assign], @current_user, {tasks: tasks, worker: worker})

    ::Services::Manager::Tasks.assign(worker, tasks)
    render text: "ok"
  end

  def merge
    tasks = ::Services::Tasks.get(params["ids"])
    Authorization.authorize!([:manager, :task_merge], @current_user, tasks)

    ::Services::Manager::Tasks.merge(tasks)
    render text: "ok"
  end

  private

  def task_params
    params.permit(:description)
  end
end
