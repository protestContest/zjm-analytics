require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "logged in user can see sites" do
    user = users(:zack)
    site = sites(:one)

    assert_equal user, site.user

    sign_in user

    get sites_url
    assert_template "sites/index"
  end

  test "unauthenticated user cannot see sites" do
    get sites_url
    assert_redirected_to new_user_session_url
  end

  test "logged in user can see owned site" do
    user = users(:zack)
    site = sites(:one)
    assert_equal user, site.user
    sign_in user

    get site_url(site)
    assert_template "sites/show"
  end

  test "unauthenticated user cannot see site" do
    site = sites(:one)
    get site_url(site)
    assert_redirected_to new_user_session_url
  end

  test "logged in user cannot see unowned site" do
    user = users(:zack)
    site = sites(:two)
    assert_not_equal user, site.user
    sign_in user

    get site_url(site)
    assert_response :forbidden
  end

  test "unauthenticated user cannot see new site form" do
    get new_site_url
    assert_redirected_to new_user_session_url
  end

  test "authenticated user can see new site form" do
    user = users(:zack)
    sign_in user
    get new_site_url
    assert_template "sites/new"
  end

  test "unauthenticated user cannot create new site" do
    post sites_url
    assert_redirected_to new_user_session_url
  end

  test "authenticated user can create new site" do
    user = users(:zack)
    sign_in user

    assert_difference('Site.count', 1) do
      post sites_url, params: { site: { name: 'New Site' } }
    end
  end

  test "unauthenticated user cannot update a site" do
    site = sites(:one)
    patch site_url(site)
    assert_redirected_to new_user_session_url
  end

  test "authenticated can update a site they own" do
    user = users(:zack)
    site = sites(:one)
    assert_equal user, site.user
    sign_in user

    patch site_url(site), params: { site: { name: 'Renamed Site' } }
    assert_redirected_to site
  end

  test "authenticated cannot update a site they do not own" do
    user = users(:zack)
    site = sites(:two)
    assert_not_equal user, site.user
    sign_in user

    patch site_url(site), params: { site: { name: 'Renamed Site' } }
    assert_response :forbidden
  end

  test "unauthenticated user cannot destroy a site" do
    site = sites(:one)
    delete site_url(site)
    assert_redirected_to new_user_session_url
  end

  test "authenticated user can destroy a site they own" do
    user = users(:zack)
    site = sites(:one)
    assert_equal user, site.user
    sign_in user

    assert_difference('Site.count', -1) do
      delete site_url(site)
    end
  end

  test "authenticated user cannot destroy a site they do not own" do
    user = users(:zack)
    site = sites(:two)
    assert_not_equal user, site.user
    sign_in user

    assert_no_difference('Site.count') do
      delete site_url(site)
    end

    assert_response :forbidden
  end

end
