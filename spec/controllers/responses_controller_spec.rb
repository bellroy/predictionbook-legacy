require 'spec_helper'

describe ResponsesController do
  include Devise::TestHelpers
  
  def post_response(params={})
    post :create, :prediction_id => '1', :response => params
  end

  before(:each) do
    controller.stub!(:set_timezone)
  end
  
  describe 'creating a new response' do
    before(:each) do
      @wagers = mock('responses', :create! => nil)
      @prediction = mock_model(Prediction,
       :to_param => '1',
       :responses => @wagers
      ).as_null_object
      Prediction.stub!(:find).and_return(@prediction)
    end
    
    describe 'when current user is signed in' do
      before(:each) do
        @user = User.new
        controller.stub(:authenticate_user!)
        controller.stub(:current_user).and_return(@user)
      end
        
      it 'should create a response on the prediction' do
        @wagers.should_receive(:create!)
        post_response
      end
    
      it 'should create the response with the posted params' do
        @wagers.should_receive(:create!).with(hash_including(:params => 'this is them'))
        post_response({:params => 'this is them'})
      end
    
      it 'should use the current user as the user' do
        @prediction.responses.should_receive(:create!).with(hash_including(:user => @user))
        post_response({})
      end
    
      it 'should redirect to the prediction show' do
        post_response
        response.should redirect_to(prediction_path('1'))
      end
      
      describe 'when the params are invalid' do
        before(:each) do
          wager = mock_model(Response, :errors => mock('errors', :full_messages => []))
          @wagers.stub!(:create!).and_raise(ActiveRecord::RecordInvalid.new(wager))
          @prediction.stub(:events)
        end
      
        it 'should respond with an http unprocesseable entity status' do
          post_response
          response.response_code.should == 422
        end
        
        it 'should render "show" form' do
          post_response
          response.should render_template('predictions/show')
        end
      
        it 'should assign the prediction' do
          post_response
          assigns[:prediction].should_not be_nil
        end
      end
    end
    
    describe 'when current user is not signed in' do     
      it 'should require the user to be logged in' do
        post_response
        response.should redirect_to(new_user_session_path)
      end
    end  
    
  end
  
  describe 'comment preview' do
    before(:each) do
      @user = User.new
      controller.stub(:authenticate_user!)
      controller.stub(:current_user).and_return(@user)
      controller.stub!(:render).with(:partial => 'responses/preview')
    end
    
    def get_preview
      get :preview, :response => { :comment => 'some text' }
    end
    
    it 'should route responses/preview to preview action' do
      {:get => "/responses/preview"}.should route_to("responses#preview")
    end
    
    it 'should respond to preview action' do
      get_preview
      response.should be_success
    end
    
    it 'should render the preview comment partial' do
      get_preview
      response.should render_template('_preview')
    end
    
    it 'should build a new response on the prediction from the params' do
      Response.should_receive(:new).with('comment' => 'some text').and_return(
        mock_model(Response).as_null_object
      )
      get_preview
    end
    
    it "should not save the comment" do
      Response.stub!(:new).and_return(response = mock_model(Response).as_null_object)
      response.should_not_receive(:save!)
      get_preview
    end
  end
  
end
