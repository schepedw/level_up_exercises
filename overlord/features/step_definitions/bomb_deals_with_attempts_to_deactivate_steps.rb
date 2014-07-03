Given(/^an active bomb$/) do
  visit "/"
  fill_in('code', :with => '1234')
  click_button('activation_button')
end

When(/^I enter the incorrect deactivation code (\d+) times$/) do |num|
  num = num.to_i
  num.times do
    fill_in('code', :with => '090990')
    click_button('activation_button')
  end
end

Then(/^the bomb explodes$/) do
  state = find(:css, 'span.state').text
  expect(state).to eql("exploded")
end

