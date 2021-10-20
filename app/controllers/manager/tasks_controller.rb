class Manager::TasksController < ApplicationController
  def list
    tasks = ::Services::Manager::Tasks.list()

    authorize(nil, :list?, policy_class: ::Policies::ManagerTaskPolicy)

    render json: tasks
  end

  def create
    authorize(nil, :create?, policy_class: ::Policies::ManagerTaskPolicy)

    if ::Services::Manager::Tasks.create(task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def update
    task = ::Services::Tasks.get(params["id"])

    authorize(task, :update?, policy_class: ::Policies::ManagerTaskPolicy)

    if ::Services::Manager::Tasks.update(task, task_params)
      render text: "ok"
    else
      render text: "error"
    end
  end

  def delete
    task = ::Services::Tasks.get(params["id"])

    authorize(task, :delete?, policy_class: ::Policies::ManagerTaskPolicy)

    ::Services::Manager::Tasks.delete(task)
    render text: "ok"
  end

  def assign
    tasks = ::Services::Tasks.get(params["task_ids"])
    worker = ::Services::Users.get(params["worker_id"])

    authorize({tasks: tasks, worker: worker}, :assign?, policy_class: ::Policies::ManagerTaskPolicy)

    ::Services::Manager::Tasks.assign(worker, tasks)
    render text: "ok"
  end

  def merge
    tasks = ::Services::Tasks.get(params["ids"])

    authorize(tasks, :merge?, policy_class: ::Policies::ManagerTaskPolicy)

    ::Services::Manager::Tasks.merge(tasks)
    render text: "ok"
  end

  private

  def task_params
    params.permit(:description)
  end
end
