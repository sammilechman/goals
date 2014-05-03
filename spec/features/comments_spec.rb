require 'spec_helper'

feature "commenting" do
  before(:each) do
    sign_up_as("foo")
    submit_new_goal("be fancy")
    click_on "Log Out"
    sign_up_as_hello_world
    visit user_url(User.find_by_username("foo"))
  end
  
  # shared examples are another way to DRY out your specs
  # have some docs: 
  # https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples
  shared_examples "comment" do
    it "should have a form for adding a new comment" do
      expect(page).to have_content "New Comment"
      expect(page).to have_field "comment"
    end
    
    it "should save the comment when a user submits one" do
      fill_in "comment", with: "my magical comment!"
      click_on "Save Comment"
      expect(page).to have_content "my magical comment!"
    end
  end
  
  feature "user profile comment" do
    it_behaves_like "comment"
  end
  
  feature "goal comment" do
    before(:each) do
      click_on "be fancy"
    end
    
    it_behaves_like "comment"
  end
end