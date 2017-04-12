require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)     # Defined in user.yml file
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'example' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
  # Simulate a user clicking logout on another window
    delete logout_path                                      # test deletes logout link
    follow_redirect!                                        # test redirect to homepage
    assert_select "a[href=?]", login_path                   # test for new login path on page
    assert_select "a[href=?]", logout_path,      count: 0   # test that no logout path is on page
    assert_select "a[href=?]", user_path(@user), count: 0   # test that user link is not on page
  end
  
  test "login with remembering" do                                          # test login with using remember cookie
    log_in_as(@user, remember_me: '1')                                      # Login to to set remember cookie
    assert_equal cookies['remember_token'], assigns(:user).remember_token   # test if remember cookie is present and is equal to user cookie
  end
  
  test "login without remembering" do         # test login without using remember cookie
    log_in_as(@user, remember_me: '1')        # Log in to set the remember me cookie
    log_in_as(@user, remember_me: '0')        # Log in again and verify that the remember me cookie is deleted
    assert_empty cookies['remember_token']    # test if remember me cookie is deleted
  end
end
