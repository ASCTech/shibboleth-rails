Rails.application.routes.draw do
  unless Rails.env.production? or Rails.env.staging?
    resource :user_session, :only => [:new, :create, :destroy]
  end
end
