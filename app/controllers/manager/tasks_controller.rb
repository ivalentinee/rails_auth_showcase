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

    authorize! :manager_task_update, task

    if ::Services::Manager::Tasks.update(task, task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def delete
    task = ::Services::Tasks.get(params["id"])

    authorize! :manager_task_delete, task

    ::Services::Manager::Tasks.delete(task)
    render text: "ok"
  end

  def assign
    tasks = ::Services::Tasks.get(params["task_ids"])
    worker = ::Services::Users.get(params["worker_id"])

    authorize! :manager_task_assign, {tasks: tasks, worker: worker}

    ::Services::Manager::Tasks.assign(worker, tasks)
    render text: "ok"
  end

  def merge
    tasks = ::Services::Tasks.get(params["ids"])

    authorize! :manager_task_merge, tasks

    ::Services::Manager::Tasks.merge(tasks)
    render text: "ok"
  end

  private

  def task_params
    params.permit(:description)
  end
end
