module Services
  module Worker
    module Tasks
      class << self
        def list(worker)
          Task.where(assignee_id: worker.id).all()
        end

        def update(task, params)
          task.update(params)
        end
      end
    end
  end
end
