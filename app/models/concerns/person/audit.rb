require 'active_support/concern'

module Concerns
  module Person
    module Audit
      extend ActiveSupport::Concern

      included do
        serialize :last_login, Hash
      end

      module ClassMethods
        def audit_last_login(person)
          if person.last_login.empty?
            person.last_login = DateTime.now
          else
            person.last_login = person.last_login.fetch(:this_login)
          end
          person.last_login = { this_login: DateTime.now.to_s, last_login: person.last_login.to_s }
          person.save(validate: false)
        end
      end

      TRACKING_COLS = %w(
        first_name
        last_name
        mobile_phone
        work_phone
        fax
        birthday
        email
        website
        about
        testimony
        business_category
        business_name
        business_description
        business_address
        business_phone
        business_email
        business_website
        anniversary
        alternate_email)
      unless defined?(TRACKING_COLS)

      end
    end
  end
end
