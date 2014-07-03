Given(/^an inactive bomb$/) do
  visit "/" 
end

When(/^I enter the correct activation code$/) do
  fill_in('code',:with => '1234')
  click_button('activation_button')
end

Then(/^the bomb is activated$/) do
  status = find(:css, 'span.state').text
  expect(status).to eql("active")
end

When(/^I enter the correct deactivation code$/) do
  fill_in('code',:with => '1234')
  click_button('activation_button')
end

Then(/^the bomb is deactivated$/) do
  status = find(:css, 'span.state').text
  expect(status).to eql("active")
end


