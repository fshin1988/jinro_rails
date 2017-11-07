class VillagePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    if user.admin?
      true
    else
      record.user_id == user.id
    end
  end

  def edit?
    update?
  end

  def destroy?
    if user.admin?
      true
    else
      record.user_id == user.id
    end
  end

  def join?
    if record.status == 'not_started'
      true
    else
      false
    end
  end
end
