class Fund < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'FundAuthorizer'

  belongs_to :site
  scope_by_site_id

  validates :name, presence: true, length: { maximum: 100 }
  validates :display_name, presence: true, length: { maximum: 10 }
  validates :active_from, presence: true

  validate :active_dates

  def active_dates
    # If entered, active_to date can't be before active_from.
    if active_to.present? && active_to < active_from
      errors.add(:active_to, I18n.t('giving.funds.validation.active_to'))
    end
  end
end
