module Policies
  class ManagerTaskPolicy < Policies::ApplicationPolicy
    def list?
      user.role == "manager"
    end

    def create?
      user.role == "manager"
    end

    def update?
      user.role == "manager" && object.managed_by.member?(user.id)
    end

    def delete?
      user.role == "manager" && object.managed_by.member?(user.id)
    end

    def assign?
      user.role == "manager" && object[:worker].managed_by.member?(user.id) && object[:tasks].all? {|task| task.managed_by.member?(user.id)}
    end

    def merge?
      user.role == "manager" && object.all? {|task| task.managed_by.member?(user.id)}
    end
  end
end
