require 'spec_helper'

feature "the signup process" do 

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up!"
  end

  it "shows username on the homepage after signup" do
    sign_up_as_hello_world
    expect(page).to have_content "Welcome hello_world"
  end

end

feature "logging in" do 

  it "shows username on the homepage after login" do
    sign_up_as_hello_world
    click_button "Log Out"
    login_as_hello_world
    expect(page).to have_content "Welcome hello_world"
  end

end

feature "logging out" do 

  it "begins with logged out state" do
    visit root_url
    expect(page).to have_content "Log In"
  end

  it "doesn't show username on the homepage after logout" do
    # TODO: write these methods AND
    # do you need to sign up again or can you just log in?
    sign_up_as_hello_world
    click_button "Log Out"
    expect(page).not_to have_content "hello_world"
  end

end
