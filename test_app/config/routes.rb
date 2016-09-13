InterpretApp::Application.routes.draw do

  mount Interpret::Engine => '/interpret'

  scope ':locale', as: 'locale' do
    get 'archives', to: 'pages#archives'
    get 'links', to: 'pages#links'
    get 'resources', to: 'pages#resources'
    get 'contact', to: 'pages#contact'

    post 'toggle_edition_mode', to: 'application#toggle_edition_mode'

    namespace :admin do
      get 'dashboard', to: 'dashboard#index'
    end

    root to: 'pages#index', :as => :root_with_locale
  end
  
  root to: redirect('/es')
end
