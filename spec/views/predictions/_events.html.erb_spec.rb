require File.dirname(__FILE__) + '/../../spec_helper'

describe "predictions/response.html.erb" do
  
  def render_partial
    render :partial => 'predictions/events', :locals => { :events => @events }
  end
  
  before(:each) do
    @wager = mock_model(Response, :created_at => Time.now).as_null_object
    @events = [@wager]
  end
  it 'should list the responses' do
    @events = [@wager,@wager]
    render_partial
    rendered.should have_selector('ul') do |l|
      l.should have_selector('li')
      l.should have_selector('li~li')
    end
  end
  it 'should show the responses relative_confidence' do
    @wager.stub!(:relative_confidence).and_return(70)
    render_partial
    rendered.should contain(/70%/)
  end
  it 'should not show nil relative_confidences' do
    @wager.should_not_receive(:relative_confidence)
    @wager.stub!(:confidence).and_return(nil)
    render_partial
  end
  it 'should show who made the response' do
    @wager.stub!(:user).and_return(User.new(:name => 'Person', :login => "login.name"))
    render_partial
    rendered.should have_selector('[class=user]', :content => 'Person')
  end      
  it 'should show when they made the response' do
    @wager.stub!(:created_at).and_return(3.days.ago)
    render_partial
    rendered.should have_selector('span', :content => '3 days ago')
  end
  it 'should show if response is in disagreement' do
    @wager.stub!(:agree?).and_return(false)
    render_partial
    rendered.should contain(/against/)
  end
  describe 'should include any supplied comments' do
    before(:each) do
      @wager.stub!(:comment).and_return(@comment = mock('comment'))
      @wager.stub!(:action_comment?).and_return(false)
    end
    it 'should show use the markup helper to render any supplied comment' do
      view.should_receive(:markup).with(@comment)
      render_partial
    end
    it 'should include the markup in the response' do
      view.stub!(:markup).and_return('<comment>markup response</comment>')
      render_partial
      rendered.should have_selector('comment', :content => 'markup response')
    end
  end
end
