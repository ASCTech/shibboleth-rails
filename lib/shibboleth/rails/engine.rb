module Shibboleth
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Shibboleth::Rails
    end
  end
end
