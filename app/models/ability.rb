class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "worker"
      worker_abilities(user)
    end

    if user.role == "manager"
      manager_abilities(user)
    end
  end

  private

  def worker_abilities(user)
    can :worker_task_update, :all, assignee: user
  end

  def manager_abilities(user)
    can :manager_task_update, :all do |task|
      task.managed_by.member?(user.id)
    end

    can :manager_task_delete, :all do |task|
      task.managed_by.member?(user.id)
    end

    can :manager_task_assign, :all do |object|
      object[:worker].managed_by.member?(user.id) && object[:tasks].all? {|task| task.managed_by.member?(user.id)}
    end

    can :manager_task_merge, :all do |tasks|
      tasks.all? {|task| task.managed_by.member?(user.id)}
    end
  end
end
