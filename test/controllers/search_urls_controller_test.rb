require 'test_helper'

class SearchUrlsControllerTest < ActionController::TestCase
  setup do
    @search_url = search_urls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_urls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_url" do
    assert_difference('SearchUrl.count') do
      post :create, search_url: { search_category_id: @search_url.search_category_id, search_site_id: @search_url.search_site_id, url: @search_url.url }
    end

    assert_redirected_to search_url_path(assigns(:search_url))
  end

  test "should show search_url" do
    get :show, id: @search_url
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_url
    assert_response :success
  end

  test "should update search_url" do
    patch :update, id: @search_url, search_url: { search_category_id: @search_url.search_category_id, search_site_id: @search_url.search_site_id, url: @search_url.url }
    assert_redirected_to search_url_path(assigns(:search_url))
  end

  test "should destroy search_url" do
    assert_difference('SearchUrl.count', -1) do
      delete :destroy, id: @search_url
    end

    assert_redirected_to search_urls_path
  end
end
