module Authorization
  class << self
    def can?(action, subject, object)
      case action
      when :worker_task_update
        subject.role == "worker" && object.assignee_id == subject.id
      when :manager_task_update
        subject.role == "manager" && object.managed_by.member?(subject.id)
      when :manager_task_delete
        subject.role == "manager" && object.managed_by.member?(subject.id)
      when :manager_task_assign
        subject.role == "manager" && object[:worker].managed_by.member?(subject.id) && object[:tasks].all? {|task| task.managed_by.member?(subject.id)}
      when :manager_task_merge
        subject.role == "manager" && object.all? {|task| task.managed_by.member?(subject.id)}
      else
        false
      end
    end

    def authorize!(action, subject, object)
      unless can?(action, subject, object)
        raise Authorization::UnauthorizedException
      end
    end
  end
end
