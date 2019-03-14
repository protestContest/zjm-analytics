require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  test "logged in user can see owned site" do
    user = users(:zack)
    site = sites(:one)
    assert site.account.users.include?(user) || site.account.owner == user
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
    assert_not_equal user, site.account.owner
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

  test "authenticated user can update a site they own" do
    user = users(:zack)
    site = sites(:one)
    assert site.account.users.include?(user) || site.account.owner == user
    sign_in user

    patch site_url(site), params: { site: { name: 'Renamed Site' } }
    assert_redirected_to site
  end

  test "authenticated cannot update a site they do not own" do
    user = users(:zack)
    site = sites(:two)
    assert_not_equal user, site.account.owner
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
    assert site.account.users.include?(user) || site.account.owner == user
    sign_in user

    assert_difference('Site.count', -1) do
      delete site_url(site)
    end
  end

  test "authenticated user cannot destroy a site they do not own" do
    user = users(:zack)
    site = sites(:two)
    assert_not_equal user, site.account.owner
    sign_in user

    assert_no_difference('Site.count') do
      delete site_url(site)
    end

    assert_response :forbidden
  end

  test "creating a site with a url starts a screenshot job" do
    assert_enqueued_with(job: ScreenshotJob) do
      user = users(:zack)
      sign_in user
      post sites_url, params: { site: { name: 'New Site', url: 'http://example.com' } }
    end
  end

  test "creating a site without a url does not start a screenshot job" do
    user = users(:zack)
    sign_in user
    post sites_url, params: { site: { name: 'New Site', url: '' } }
    assert_no_enqueued_jobs
  end

  test "updating a site with a url starts a screenshot job" do
    assert_enqueued_with(job: ScreenshotJob) do
      user = users(:zack)
      site = sites(:one)
      assert site.account.users.include?(user) || site.account.owner == user
      sign_in user

      patch site_url(site), params: { site: { name: 'Renamed Site', url: 'http://example.com' } }
    end
  end

  test "updating a site without a url does not start a screenshot job" do
    user = users(:zack)
    site = sites(:one)
    assert site.account.users.include?(user) || site.account.owner == user
    sign_in user

    patch site_url(site), params: { site: { name: 'Renamed Site', url: '' } }
    assert_no_enqueued_jobs
  end

end
