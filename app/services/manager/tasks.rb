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

        def update(task, params)
          task.update(params)
        end

        def delete(task)
          task.destroy
        end

        def assign(worker, tasks)
          tasks.each do |task|
            task.assignee = worker
            task.save!
          end
        end

        def merge(tasks)
          task_descriptions = tasks.map {|task| task.description}
          merged_description = task_descriptions.join("\n")

          Task.create({description: merged_description})

          tasks.each {|task| task.destroy}
        end
      end
    end
  end
end
