# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "worker"
      can :worker_task_update, :all, assignee: user
    end

    if user.role == "manager"
      can :manager_task_update, :all do |task|
        task.managed_by.member?(user.id)
      end

      can :manager_task_delete, :all do |task|
        task.managed_by.member?(user.id)
      end

      can :manager_task_assign, :all do |object|
        object[:worker].managed_by.member?(user.id) && object[:tasks].all? {|task| task.managed_by.member?(user.id)}
      end

      can :manager_task_merge, :all do |object|
        object.all? {|task| task.managed_by.member?(user.id)}
      end
    end
  end
end
