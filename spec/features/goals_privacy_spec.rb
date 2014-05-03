require 'spec_helper'

feature "goal privacy" do
  before(:each) do
    sign_up_as_hello_world
  end
  describe "public goals" do
    it "should create public goals by default" do
      submit_new_goal("build a tesla coil")
      expect(page).to have_content "Public"
    end
    
    it "shows public goals when logged out" do
      submit_new_goal("wear socks")
      click_button "Log Out"
      visit user_url(User.find_by_username("hello_world"))
      expect(page).to have_content "wear socks"
    end
    
    it "allows other users to see public goals" do
      submit_new_goal("learn kung fu")
      click_button "Log Out"
      sign_up_as("foo_bar")
      visit user_url(User.find_by_username("hello_world"))
      expect(page).to have_content "learn kung fu"
    end
  end
  
  describe "private goals" do
    it "allows creating private goals" do
      submit_new_goal("top secret goal~", private: true)
      expect(page).to have_content "Private"
    end
    
    it "hides private goals when logged out" do
      submit_new_goal("top secret goal~", private: true)
      click_button "Log Out"
      visit user_url(User.find_by_username("hello_world"))
      expect(page).not_to have_content "top secret goal~"
    end
    
    it "hides private goals from other users" do
      submit_new_goal("top secret goal~", private: true)
      click_button "Log Out"
      sign_up_as("foo_bar")
      visit user_url(User.find_by_username("hello_world"))
      expect(page).not_to have_content "top secret goal~"
    end
  end
end