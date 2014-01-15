module Shibboleth::Rails

  module ModelAdditions
    def authenticated_by_shibboleth
      extend ClassMethods
      include InstanceMethods
    end

    module ClassMethods
      def find_or_create_from_shibboleth(identity)
        affiliations    = identity.delete(:affiliations)
        first_name      = identity.delete(:first_name)
        last_name       = identity.delete(:last_name)

        # We'll loop over the identity (emplid & name_n) and attempt to find a
        # user matching it's key/value pair. If they exist then we'll use them,
        # otherwise we'll have to create a new one...

        user = where(emplid: identity[:emplid]).first || where(name_n: identity[:name_n]).first || create!(identity)

        # names change due to marriage, etc.
        # update_attribute is a NOOP if not different

        user.update_attribute(:name_n, identity[:name_n])
        user.update_attribute(:emplid, identity[:emplid])
        user.update_attribute(:first_name, first_name) if user.class.columns.map(&:name).include?('first_name') && first_name.present?
        user.update_attribute(:last_name, last_name) if user.class.columns.map(&:name).include?('last_name') && last_name.present?

        user.update_role(affiliations) if user.respond_to?(:update_role)
        user
      end
    end

    module InstanceMethods
      def update_usage_stats(request, args = {})
        if args[:login]
          if self.respond_to?(:login_count)
            self.login_count ||= 0
            self.login_count  += 1
          end

          if self.respond_to?(:current_login_at)
            self.last_login_at = self.current_login_at if self.respond_to?(:last_login_at)
            self.current_login_at = Time.now
          end

          if self.respond_to?(:current_login_ip)
            self.last_login_ip = self.current_login_ip if self.respond_to?(:last_login_ip)
            self.current_login_ip = request.remote_ip
          end

          self.login_callback(request, args) if self.respond_to?(:login_callback)

          save(:validate => false)

        end

        self.request_callback(request, args) if self.respond_to?(:request_callback)
      end
    end

  end
end

::ActiveRecord::Base.send :extend, Shibboleth::Rails::ModelAdditions
