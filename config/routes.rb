Rails.application.routes.draw do
  root 'images#new'

  resources :images
end
