module Shibboleth::Rails
  class UserSessionsController < ::ApplicationController
    include Shibboleth::Rails::Concerns::Controllers::UserSessionsController
  end
end
