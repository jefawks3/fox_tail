Rails.application.routes.draw do
  get :clients, to: "clients#index"
  mount Lookbook::Engine, at: "/"
end
