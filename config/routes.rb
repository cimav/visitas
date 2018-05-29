Rails.application.routes.draw do
  resources :room_visits
  resources :visits
  resources :rooms

  get '/get_institutions' => 'visits#get_institutions'
end
