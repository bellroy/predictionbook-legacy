require 'spec_helper'

describe 'predictions/new.html.erb' do
  before(:each) do
    errors = mock('errors', :on => nil)
    assigns[:prediction] = @prediction = stub_model(Prediction).as_new_record
    view.stub!(:user_statistics_cache_key).and_return "stats"
    view.stub!(:statistics).and_return(Statistics.new([])) 
    @user = mock_model(User, :has_email? => false)
    view.stub!(:user_signed_in?).and_return(true)
    view.stub!(:current_user).and_return(@user)
    view.stub!(:cache).and_yield
    @user.stub!(:to_param).and_return "username"
  end
  
  it "should look up the user cache key for the current user" do
    @view.should_receive(:user_statistics_cache_key).with(@user)
    render
  end
  
  it 'should cache a fragment for the statistics partial' do
    lambda {
      render
    }.should cache_fragment("views/stats")
  end
  
  it 'should have a form that POSTs to the prediction collection' do
    render
    rendered.should have_selector("form",
                                  :method => "post",
                                  :action => predictions_path
                                  )
  end
  
  it 'should have a hidden field with the predictions UUID' do
    #@prediction.stub!(:uuid).and_return('0d027d60-7b04-11dd-92d8-001f5b80f5b2')
    @prediction.uuid = '0d027d60-7b04-11dd-92d8-001f5b80f5b2'
    render
    rendered.should have_selector("input",
                                  :id => "prediction_uuid",
                                  :name => 'prediction[uuid]',
                                  :type => "hidden",
                                  :value => '0d027d60-7b04-11dd-92d8-001f5b80f5b2'
                                  )
 
  end
  
  it 'should have an input field for prediction description' do
    render
    rendered.should have_selector("textarea",
                                  :id => "prediction_description",
                                  :name => 'prediction[description]' 
                                 )
  end
  
  it 'should have an input field for the initial confidence' do
    render
    rendered.should have_selector("input",
                                  :id => 'prediction_initial_confidence',
                                  :name => 'prediction[initial_confidence]',
                                  :type => 'text' 
                                 )
  end

  describe '(check box for the notify creator)' do
    it 'should be present and checked when user has an email' do
      @prediction.stub!(:notify_creator).and_return true
      render
      rendered.should have_selector("input",
                                  :id => 'prediction_notify_creator',
                                  :name => 'prediction[notify_creator]',
                                  :type => 'checkbox',
                                  :checked =>  'checked'
                                 )
    end
    
    it 'should be unchecked if user does not have email' do
      @prediction.stub!(:notify_creator).and_return false
      render
      rendered.should_not have_selector("input",
                                  :id => 'prediction_notify_creator',
                                  :name => 'prediction[notify_creator]',
                                  :type => 'checkbox',
                                  :checked =>  'checked'
                                 )
    end
  end
  
  describe '(check box for private)' do
    it 'should be present' do
      render
      rendered.should have_selector("input",
                                  :id => 'prediction_private',
                                  :type => 'checkbox',
                                  :name => 'prediction[private]'
                                  ) 
    end
    
    it 'should be checked when user private_default is true' do
      @prediction.stub!(:private).and_return true
      render
      rendered.should have_selector('input',
                                  :type => 'checkbox',
                                  :name => 'prediction[private]',
                                  :checked => 'checked'
                                  ) 
    end
    it 'should not be checked when user private_default is false' do
      @prediction.stub!(:private).and_return false
      render
      rendered.should_not have_selector('input',
                                  :type => 'checkbox',
                                  :name => 'prediction[private]',
                                  :checked => 'checked'
                                  ) 
    end
  end
  
  it 'should have an input field for the result' do
    render
    rendered.should have_selector('input',
                                  :id => 'prediction_deadline_text',
                                  :type => 'text',
                                  :name => 'prediction[deadline_text]'
                                  ) 
  end
  
  it 'should have a submit button' do
    render
    rendered.should have_selector('input',
                                      :type => 'submit', 
                                      :value => 'Lock it in!'
                                     )
  end
end
