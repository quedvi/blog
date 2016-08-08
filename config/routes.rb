Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  get '/welcome(/:year(/:month))' => "welcome#index", :as => 'calendar'
  get '/rps(/:choice)' => "welcome#rps", :as => 'rps'

  resources :articles do
    get 'page/:page', :action => :index, :on => :collection
    resources :comments
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
