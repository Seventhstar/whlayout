require 'test_helper'

class SearchCategoriesControllerTest < ActionController::TestCase
  setup do
    @search_category = search_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_category" do
    assert_difference('SearchCategory.count') do
      post :create, search_category: { name: @search_category.name }
    end

    assert_redirected_to search_category_path(assigns(:search_category))
  end

  test "should show search_category" do
    get :show, id: @search_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_category
    assert_response :success
  end

  test "should update search_category" do
    patch :update, id: @search_category, search_category: { name: @search_category.name }
    assert_redirected_to search_category_path(assigns(:search_category))
  end

  test "should destroy search_category" do
    assert_difference('SearchCategory.count', -1) do
      delete :destroy, id: @search_category
    end

    assert_redirected_to search_categories_path
  end
end
