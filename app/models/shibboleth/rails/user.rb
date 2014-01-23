module Shibboleth
  module Rails
    class User < ActiveRecord::Base
      self.table_name = :users

      include Shibboleth::Rails::Concerns::Models::User
    end
  end
end

