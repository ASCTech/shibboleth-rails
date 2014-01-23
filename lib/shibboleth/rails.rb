module Shibboleth
  module Rails
    LIVE_ENVS = %w[production staging]
  end
end

require "shibboleth/rails/engine"
require "shibboleth/rails/version"

# Model Concerns

require "shibboleth/rails/concerns/models/user"

# Controller Concerns

require "shibboleth/rails/concerns/controllers/application_controller"
require "shibboleth/rails/concerns/controllers/user_sessions_controller"

