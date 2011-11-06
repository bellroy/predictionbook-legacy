require 'spec_helper'

describe 'Application Layout' do
  include Devise::TestHelpers
  
  def render_me!
    render :template => 'layouts/application.html.erb'
  end
  
  describe 'when user not logged in' do
    before(:each) do
      view.stub!(:logged_in?).and_return(false)
    end
    
    it 'should not show username' do
      view.should_not_receive(:show_user)
      render_me!
    end
    
    it 'should not show logout link' do
      render_me!
      rendered.should_not have_selector(%Q{a[href="#{destroy_user_session_path}"]})
    end
  end
  
  describe 'for a logged in user' do
    before(:each) do
      view.stub!(:user_signed_in?).and_return(true)
      view.stub!(:current_user).and_return(mock_model(User))
    end
    
    it 'should show link to username' do
      view.should_receive(:show_user)
      render_me!
    end
    
    it 'should show link to settings page' do
      render_me!
      rendered.should have_selector(%Q{a[href="#{edit_user_registration_path}"]})
    end
    
    it 'should show logout link' do
      render_me!
      rendered.should have_selector(%Q{a[href="#{destroy_user_session_path}"]})
    end
  end
end
