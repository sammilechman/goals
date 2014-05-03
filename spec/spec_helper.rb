# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end


def sign_up_as(username)
  visit new_user_url
  fill_in "user[username]", with: username
  fill_in "user[password]", with: "password"
  click_button "Sign Up"
end

def sign_up_as_hello_world
  sign_up_as("hello_world")
end

def login_as_hello_world
  visit new_session_url
  fill_in "user[username]", with: "hello_world"
  fill_in "user[password]", with: "password"
  click_button "Log In"
end

def submit_new_goal(goal_title, privacy = {private: false})
  visit new_goal_url
  fill_in "goal[title]", with: goal_title
  if privacy[:private]
    check "goal_private"
  end
  click_button "New Goal"
end

def build_three_goals
  submit_new_goal("pickle a pepper")
  submit_new_goal("get octocat's autograph")
  submit_new_goal("bake a cake")
end

def verify_three_goals
  visit goals_url
  expect(page).to have_content "pickle a pepper"
  expect(page).to have_content "get octocat's autograph"
  expect(page).to have_content "bake a cake"
end

def prep_cheer_from(cheerer)
  sign_up_as_hello_world
  submit_new_goal("eat six saltines in a minute")
  click_button "Log Out"
  sign_up_as("foo")
end

def give_cheer_to(cheered_user)
  visit user_url(User.find_by_username(cheered_user))
  click_button "Cheer!"
end

def give_another_cheer
  click_button "Log Out"
  next_username = Faker::Internet.user_name
  sign_up_as(next_username)
  next_goal = Faker::Lorem.words(3).join(" ")
  submit_new_goal(next_goal)
  click_button "Log Out"
  login_as_hello_world
  visit user_url(User.find_by_username(next_username))
  click_button "Cheer!"
end