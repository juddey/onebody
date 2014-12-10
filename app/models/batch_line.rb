class BatchLine < ActiveRecord::Base
  belongs_to :person
  belongs_to :fund
end
