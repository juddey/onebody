class BatchLine < ActiveRecord::Base
  belongs_to :person
  belongs_to :fund
  belongs_to :batch

  validates :tender,
            allow_nil: false,
            inclusion: { in: %w(Cash Cheque Online) }

end
