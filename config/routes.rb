Rails.application.routes.draw do
  resources :room_visits
  resources :visits
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
