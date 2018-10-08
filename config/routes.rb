Rails.application.routes.draw do
  get 'departments/index'
  get 'departments/new'
  get 'departments/edit'
  resources :room_visits
  resources :visits
  resources :rooms
  resources :departments, except: [:show]

  root 'visits#index'
  get '/get_institutions' => 'visits#get_institutions'
  get '/load_visits' => 'visits#load_visits'
  post '/visits/:id/create_room_visit' => 'visits#create_room_visit'
  get '/visits/edit_room_visit/:room_visit_id' => 'visits#edit_room_visit'
  get '/visits/edit_visit_person/:visit_person_id' => 'visits#edit_visit_person'
  patch '/visits/update_room_visit/:room_visit_id' => 'visits#update_room_visit'
  patch '/visits/update_visit_person/:visit_person_id' => 'visits#update_visit_person'
  delete '/visits/delete_visit_person/:visit_person_id' => 'visits#delete_visit_person'
  delete '/visits/delete_visit_person_token/:visit_person_id' => 'visits#delete_visit_person_with_token'
  post '/visits/:id/upload_file' => 'visits#upload_file'
  post '/visits/:token/upload_file_token' => 'visits#upload_file_with_token'
  get '/visits/token/:token' => 'visits#access_with_token'
  get '/public_new_visit' => 'visits#public_new_visit'
  post '/public_create_visit' => 'visits#public_create_visit'
  get '/visit_success' => 'visits#visit_success'
  get '/visits/:id/load_people' => 'visits#visit_people'
  post '/visits/:id/add_person' => 'visits#add_person'
  post '/visits/:token/confirm_visit' => 'visits#confirm_visit'


  ########################################## sesiones
  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get '/logout' => 'sessions#destroy'
end
