Shibboleth::Rails::Engine.routes.draw do
  unless ::Rails.env.in? Shibboleth::Rails::LIVE_ENVS
    resource :user_session, :only => [:new, :create, :destroy]
  end
end
