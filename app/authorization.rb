module Authorization
  class << self
    def can?(action, subject, object)
      case subject.role
      when "manager"
        manager_can?(action, subject, object)
      when "worker"
        worker_can?(action, subject, object)
      else
        false
      end
    end

    def authorize!(action, subject, object)
      unless can?(action, subject, object)
        raise Authorization::UnauthorizedException
      end
    end

    private

    def manager_can?(action, subject, object)
      case action
      when :manager_task_update
        object.managed_by.member?(subject.id)
      when :manager_task_delete
        object.managed_by.member?(subject.id)
      when :manager_task_assign
        object[:worker].managed_by.member?(subject.id) && object[:tasks].all? {|task| task.managed_by.member?(subject.id)}
      when :manager_task_merge
        object.all? {|task| task.managed_by.member?(subject.id)}
      else
        false
      end
    end

    def worker_can?(action, subject, object)
      case action
      when :worker_task_update
        subject.role == "worker" && object.assignee_id == subject.id
      else
        false
      end
    end
  end
end
