Rails.application.routes.draw do
  root 'home#show'
  get 'home/show'
  resources :images
end
