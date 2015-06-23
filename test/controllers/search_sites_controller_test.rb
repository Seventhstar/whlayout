require 'test_helper'

class SearchSitesControllerTest < ActionController::TestCase
  setup do
    @search_site = search_sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_site" do
    assert_difference('SearchSite.count') do
      post :create, search_site: { name: @search_site.name }
    end

    assert_redirected_to search_site_path(assigns(:search_site))
  end

  test "should show search_site" do
    get :show, id: @search_site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_site
    assert_response :success
  end

  test "should update search_site" do
    patch :update, id: @search_site, search_site: { name: @search_site.name }
    assert_redirected_to search_site_path(assigns(:search_site))
  end

  test "should destroy search_site" do
    assert_difference('SearchSite.count', -1) do
      delete :destroy, id: @search_site
    end

    assert_redirected_to search_sites_path
  end
end
