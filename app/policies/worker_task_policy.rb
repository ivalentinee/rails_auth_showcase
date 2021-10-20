module Policies
  class WorkerTaskPolicy < Policies::ApplicationPolicy
    def list?
      user.role == "worker"
    end

    def update?
      user.role == "worker" && object.assignee_id == user.id
    end
  end
end
