Predictionbook::Application.routes.draw do
  devise_for :users
  
  resources :users do
    member do
      get :settings
    end
    resources :deadline_notifications
  end
  
  resources :deadline_notifications
  resources :response_notifications
  match '/feedback' => "feedback#show"
  
  resources :responses do
    collection do
      get :preview
    end
  end

  resources :predictions do
    collection do
      get :unjudged
      get :judged
      get :future
      get :recent
    end
    
    member do
      post :judge
      post :withdraw
    end
    
    resources :responses do
      collection do
        get :preview
      end
    end
  end

  match '/happenstance' => 'predictions#happenstance', :as => :happenstance
  root :to => "predictions#home"
end

