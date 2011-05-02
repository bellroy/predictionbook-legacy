require 'pathname'
require Pathname(File.dirname(__FILE__)).parent.parent + 'spec' + 'support' + 'factories' + 'model_factory'
include ModelFactory

Then /^I should see the response form$/ do
  response.should have_tag(%Q{form[action="#{prediction_responses_path(@prediction)}"]}) do
    with_tag 'textarea[name=?]', 'response[comment]'
  end
end

Then /^the form should not have a field for entering a confidence$/ do
  response.should_not have_tag('form input[name=?]','response[confidence]')
end

Given /^I take note of the response count$/ do
  @response_count = @prediction.responses.count
end

When /^I submit a confidence$/ do
  post prediction_responses_path(@prediction), :response => {:confidence => '90'}
end

Then /^the response code should be 422$/ do
  response.code.should == '422'
end

Then /^The response count should be unchanged$/ do
  @prediction.responses.count.should == @response_count
end
