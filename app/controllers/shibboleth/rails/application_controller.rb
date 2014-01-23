module Shibboleth
  module Rails
    class ApplicationController < ActionController::Base
      include Shibboleth::Rails::Concerns::Controllers::ApplicationController
    end
  end
end
