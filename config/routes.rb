Rails.application.routes.draw do
  resources :room_visits
  resources :visits
  resources :rooms

  root 'visits#index'
  get '/get_institutions' => 'visits#get_institutions'
  get '/load_visits' => 'visits#load_visits'
  post '/visits/:id/create_room_visit' => 'visits#create_room_visit'
  get '/visits/edit_room_visit/:room_visit_id' => 'visits#edit_room_visit'
  patch '/visits/update_room_visit/:room_visit_id' => 'visits#update_room_visit'
  post '/visits/:id/upload_file' => 'visits#upload_file'
  get '/visits/token/:token' => 'visits#access_with_token'
  get '/public_new_visit' => 'visits#public_new_visit'
  post '/public_create_visit' => 'visits#public_create_visit'
  get '/visit_success' => 'visits#visit_success'
end
