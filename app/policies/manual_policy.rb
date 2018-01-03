class ManualPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    if user.admin?
      true
    else
      false
    end
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
