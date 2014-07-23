Then(/^the image matches the status$/) do
  status = find(:css, 'span.state').text
  expect(page.has_css?("div.#{status}")).to be true
end

Given(/^an exploded bomb$/) do
  visit "/"
  fill_in('code', :with =>"1234")
  click_button('activation_button')
  3.times do
    fill_in('code', :with => "1235123")
    click_button('activation_button')
  end
end

Then(/^the code input field is gone$/) do
  expect{find(:css, '#code_input')}.to raise_error(Capybara::ElementNotFound)
end

Then(/^the submit button is gone$/) do
  expect{find(:css, '#activation_button')}.to raise_error(Capybara::ElementNotFound)
end
