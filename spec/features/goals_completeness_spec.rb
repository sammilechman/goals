require 'spec_helper'

feature "goal completeness tracking" do
  before(:each) do
    sign_up_as_hello_world
    submit_new_goal("take over the world")
  end
  describe "goals start out uncompleted" do
    context "on the goal show page" do
      it "starts as not completed" do
        visit goal_url(Goal.find_by_title("take over the world"))
        expect(page).to have_content("Ongoing")
      end
    end
    
    context "on the goal index page" do
      it "starts as not completed" do
        visit goals_url
        expect(page).to have_content("Ongoing")
      end
    end
    
    context "on the user's profile page" do
      it "starts as not completed" do
        visit user_url(User.find_by_username("hello_world"))
        expect(page).to have_content("Ongoing")
      end
    end
  end
  
  describe "marking a goal as completed" do
    context "on the goal show page" do
      it "allows user to change goal to completed" do
        visit goal_url(Goal.find_by_title("take over the world"))
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Complete")
      end
      it "redirects to the same page after updating goal" do
        visit goal_url(Goal.find_by_title("take over the world"))
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Goal:")
        expect(page).to have_content("Title:")
        expect(page).to have_content("take over the world")
      end
      it "disallows editing completeness when it is not your goal" do
        click_button "Log Out"
        sign_up_as("foo")
        visit goal_url(Goal.find_by_title("take over the world"))
        expect(page).not_to have_button("Complete")
      end
    end
    
    context "on the goal index page" do
      it "allows user to change goal to completed" do
        visit goals_url
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Complete")
      end
      it "redirects to the same page after updating goal" do
        visit goals_url
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Your Goals")
      end
    end
    
    context "on the user's profile page" do
      it "allows user to change goal to completed" do
        visit user_url(User.find_by_username("hello_world"))
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Complete")
      end
      it "redirects to the same page after updating goal" do
        visit user_url(User.find_by_username("hello_world"))
        click_button "goal_#{Goal.find_by_title('take over the world').id}_completed"
        expect(page).to have_content("Complete")
        expect(page).to have_content("Hello_world's Profile")
        expect(page).to have_content("Hello_world's Goals:")
      end
      it "disallows editing completeness when it is not your goal" do
        click_button "Log Out"
        sign_up_as("foo")
        visit user_url(User.find_by_username("hello_world"))
        expect(page).not_to have_button("Complete")
      end
    end
  end
end