ActionController::Routing::Routes.draw do |map|
  
  map.with_options(:controller => 'sessions') do |sessions|
    sessions.logout '/logout',:action => 'destroy'
    sessions.login '/login', :action => 'new'
  end
  map.resource :session
  
  map.with_options(:controller => 'users') do |users|
    users.register '/register', :action => 'create'
    users.signup '/signup', :action => 'new'
  end
  
  map.resources :users, :member => {:settings => :get}, :has_many => :deadline_notifications

  map.resources :deadline_notifications
  map.resources :response_notifications

  map.resource :feedback, :controller => 'feedback'
  map.resources :responses, :collection => { :preview => :get }
  
  map.resources :predictions,
    :collection => {
      :recent => :get,
      :unjudged => :get,
      :judged => :get,
      :future => :get
    }, :member => {
      :withdraw => :post,
      :judge => :post
    } do |p|
    p.resources :responses, :collection => {:preview => :get}
  end
  map.with_options(:controller => 'predictions') do |predictions|
    # urls should be canonical
    predictions.happenstance  '/happenstance', :action => 'happenstance'
    predictions.root :action => 'home'
  end
end
