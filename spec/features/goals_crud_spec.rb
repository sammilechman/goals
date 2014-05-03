require 'spec_helper'

feature "CRUD of goals" do
  before(:each) do
    sign_up_as_hello_world
  end
  feature "creating goals" do
    it "should have a page for creating a new goal" do
      visit new_goal_url
      expect(page).to have_content "New Goal"
    end
    it "should show the new goal after creation" do
      submit_new_goal("have some toes")
      expect(page).to have_content "have some toes"
      expect(page).to have_content "Goal saved!"
    end
  end

  feature "reading goals" do
    it "should list goals" do
      build_three_goals
      verify_three_goals
    end
  end

  feature "updating goals" do
    it "should have a page for updating an existing goal" do
      submit_new_goal("visit the moon")
      visit edit_goal_url(Goal.find_by_title("visit the moon"))
      expect(page).to have_content "Edit Goal"
      find_field('goal[title]').value.should eq 'visit the moon'
    end
    it "should show the updated goal after changes are saved" do
      submit_new_goal("visit the moon")
      visit edit_goal_url(Goal.find_by_title("visit the moon"))
      fill_in "goal[title]", with: "visit the sun"
      click_button "Update Goal"
      find_field('goal[title]').value.should eq 'visit the sun'
      expect(page).to have_content "Goal updated!"
    end
  end

  feature "deleting goals" do
    it "should allow the deletion of a goal" do
      build_three_goals
      visit goals_url
      click_button "delete 'pickle a pepper' goal"
      expect(page).not_to have_content "pickle a pepper"
      expect(page).to have_content "Goal deleted!"
    end
  end
end

