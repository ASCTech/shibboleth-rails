module Shibboleth
  module Rails
    class ApplicationController < ::ApplicationController
      include Shibboleth::Rails::Concerns::Controllers::ApplicationController
    end
  end
end
