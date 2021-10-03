module Services
  module Worker
    module Tasks
      class << self
        def list(worker)
          Task.where(assignee_id: worker.id).all()
        end

        def update(id, params)
          task = Task.find(id)
          task.update(params)
        end
      end
    end
  end
end
