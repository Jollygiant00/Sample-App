require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup                   # method for logging in test user
    @user = users(:michael)   # setting user equal to user in yml file
    remember(@user)           # utilizing remember token for user
  end
  
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end