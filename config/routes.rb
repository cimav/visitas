Rails.application.routes.draw do
  resources :room_visits
  resources :visits
  resources :rooms

  root 'visits#index'
  get '/get_institutions' => 'visits#get_institutions'
  get '/load_visits' => 'visits#load_visits'
end
