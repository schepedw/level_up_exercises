When(/^I am on the home page$/) do
  visit "/"
end

Then(/^I should see the bomb's status$/) do
  status = find(:css, 'span.state').text
  length = status.strip.length
  expect(length).to be > 0
  expect(status).to eql("inactive")
end

Then(/^I should see a field to enter the activation\/deactivation code$/) do
  form = find(:css, '#code_input')
  expect(form).to be_truthy
end

Then(/^I should see a submit button with which to submit the activation\/deactivation code$/) do
  button = find(:css, '#activation_button')
  expect(button).to be_truthy
end


