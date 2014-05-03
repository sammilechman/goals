require 'spec_helper'

feature "giving cheers" do
  before(:each) do
    prep_cheer_from("foo")
  end
  it "lets a user give a cheer for another user's goal" do
    give_cheer_to("hello_world")
    expect(page).to have_content("You cheered hello_world's goal!")
    expect(page).not_to have_button "Cheer!"
  end
  it "does not let a user cheer their own goals" do
    submit_new_goal("fly a kite")
    expect(page).not_to have_button "Cheer!"
    visit user_url(User.find_by_username("foo"))
    expect(page).not_to have_button "Cheer!"
  end
  it "does not let the user cheer the same goal twice" do
    give_cheer_to("hello_world")
    expect(page).not_to have_button "Cheer!"
  end
end

feature "viewing my cheers" do
  before(:each) do
    prep_cheer_from("foo")
    give_cheer_to("hello_world")
    click_button "Log Out"
    login_as_hello_world
  end
  it "lets a user see the number of cheers given for their goal" do
    visit goal_url(Goal.find_by_title("eat six saltines in a minute"))
    expect(page).to have_content "Cheers: 1"
  end
  it "has a cheer index that shows the cheers with their info" do
    visit cheers_url
    expect(page).to have_content "Cheer given by:"
    expect(page).to have_content "foo"
    expect(page).to have_content "For goal of:"
    expect(page).to have_content "eat six saltines in a minute"
  end
end

feature "limit on cheers" do
  before(:each) do
    sign_up_as_hello_world
    visit user_url(User.find_by_username("hello_world"))
    @limit = page.find("#cheer-limit").text.to_i
    puts "Limit found: #{@limit}"
  end
  it "displays remaining cheers for the day to logged in user on profile" do
    expect((@limit > 0)).to be_true
  end
  it "does not allow giving more cheers than the limit" do
    until @limit == 0
      give_another_cheer
      @limit = page.find("#cheer-limit").text.to_i
    end
    # attempt going over the cheer limit
    expect(page).not_to have_button "Cheer!"
  end
end

# More great ideas for specs:
# Each goal should have it's own cheer button
# pushing the 'Cheer' button for one goal should not change other goals
# pushing the button only decreases cheer count by 1
# and removing cheers should be allowed