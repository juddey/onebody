class BatchAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    user.admin?(:record_giving)
  end

  def creatable_by?(user)
    user.admin?(:manage_giving)
  end

  alias_method :updatable_by?, :creatable_by?
  alias_method :deletable_by?, :creatable_by?
end
