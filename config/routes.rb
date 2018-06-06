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
end
