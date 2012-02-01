Rails.application.routes.draw do
  unless Rails.env.production?
    resource :user_session, :only => [:new, :create, :destroy]
  end
end
