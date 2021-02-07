Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'page_not_found', to: 'pages#not_found'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  get '/notes/:id/export', to: 'notes#export', as: 'export_note'
  get '/books/:id/export', to: 'books#export', as: 'export_book'
  get 'books/mass_export', to: 'books#mass_export', as: 'export_all_books'
  resources :notes
  resources :books
  resources :users, except: [ :new, :index ]
  # get 'my_notes', 'notes#all_index'
end
