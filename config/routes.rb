Interpret::Engine.routes.draw do
  scope ':locale' do
    resources :translations, only: [:destroy, :edit, :update, :create] do
      collection do
        get :live_edit
      end
    end

    resources :tools, only: :index do
      collection do
        get :export
        post :import
        post :dump
        post :run_update
      end
    end

    match 'search', to: 'search#index', via: [:get, :post]
    resources :missing_translations
    get 'blank', to: 'missing_translations#blank', as: 'blank_translations'
    get 'unused', to: 'missing_translations#unused', as: 'unused_translations'
    get 'stale', to: 'missing_translations#stale', as: 'stale_translations'

    root to: 'translations#index'
  end

  get '/', to: 'translations#welcome'
end
