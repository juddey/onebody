class FundAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    user.admin?(:manage_giving)
  end

  alias_method :creatable_by?, :readable_by?
  alias_method :updatable_by?, :readable_by?
  alias_method :deletable_by?, :readable_by?
end
