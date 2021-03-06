Rails.application.routes.draw do
  # concern :searchable, Blacklight::Routes::Searchable2.new
  mount Blacklight::Engine => '/'
  root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get ':locale', to: 'catalog#index'
 # get 'editions/any/2009/jul/editions/:locale',   to: 'catalog#index'
  get ':medium/:collection/:year/:month/:edition/:locale',   to: 'catalog#index'
  post ':medium/:collection/:year/:month/:edition/object:obj_id/:locale/track', to: 'catalog#track'
  get ':medium/:collection/:year/:month/:edition/object:obj_id/:locale',   to: 'catalog#show'
  get ':medium/:collection/:year/:month/:edition/subject:subj_id/:locale', to: 'catalog#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

