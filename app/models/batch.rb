class Batch < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'BatchAuthorizer'

  belongs_to :site
  scope_by_site_id

  validates :name, presence: true, length: { maximum: 30 }
  validates :opening_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :status,
            allow_nil: false,
            inclusion: { in: %w(Open Closed),
                         message: I18n.t('giving.batch.validation.status') }
  validates :batch_type,
            allow_nil: false,
            inclusion: { in: %w(Online Manual),
                         message: I18n.t('giving.batch.validation.type') }

  validate :opening_date_validator

  def opening_date_validator
    if (deposit_date.present? && opening_date.present?) && deposit_date < opening_date
      errors.add(:deposit_date, I18n.t('giving.batch.validation.deposit_date'))
    end
  end
end
