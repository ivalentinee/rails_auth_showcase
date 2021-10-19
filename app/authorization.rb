module Authorization
  class << self
    def can?(action, subject, object)
      action_group, *action_name = action

      case action_group
      when :manager
        manager_can?(action_name, subject, object)
      when :worker
        worker_can?(action_name, subject, object)
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
      return false unless subject.role == "manager"

      case action
      when [:task_update]
        object.managed_by.member?(subject.id)
      when [:task_delete]
        object.managed_by.member?(subject.id)
      when [:task_assign]
        object[:worker].managed_by.member?(subject.id) && object[:tasks].all? {|task| task.managed_by.member?(subject.id)}
      when [:task_merge]
        object.all? {|task| task.managed_by.member?(subject.id)}
      else
        false
      end
    end

    def worker_can?(action, subject, object)
      return false unless subject.role == "worker"

      case action
      when [:task_update]
        object.assignee_id == subject.id
      else
        false
      end
    end
  end
end
