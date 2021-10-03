module Services
  module Manager
    module Tasks
      class << self
        def list
          Task.all()
        end

        def create(params)
          Task.create(params)
        end

        def update(id, params)
          task = Task.find(id)
          task.update(params)
        end

        def delete(id)
          task = Task.find(id)
          task.destroy
        end

        def assign(id, worker_id)
          task = Task.find(id)
          worker = User.where(role: "worker").find(worker_id)
          task.assignee = worker
          task.save!
        end

        def merge(ids)
          tasks = Task.find(ids)
          task_descriptions = tasks.map {|task| task.description}
          merged_description = task_descriptions.join("\n")

          Task.create({description: merged_description})

          tasks.each {|task| task.destroy}
        end
      end
    end
  end
end
