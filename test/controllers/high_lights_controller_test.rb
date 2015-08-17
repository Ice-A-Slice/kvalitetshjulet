require 'test_helper'

class HighLightsControllerTest < ActionController::TestCase
  setup do
    @high_light = high_lights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:high_lights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create high_light" do
    assert_difference('HighLight.count') do
      post :create, high_light: { color: @high_light.color, comment: @high_light.comment, user_id: @high_light.user_id, week: @high_light.week, year: @high_light.year }
    end

    assert_redirected_to high_light_path(assigns(:high_light))
  end

  test "should show high_light" do
    get :show, id: @high_light
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @high_light
    assert_response :success
  end

  test "should update high_light" do
    patch :update, id: @high_light, high_light: { color: @high_light.color, comment: @high_light.comment, user_id: @high_light.user_id, week: @high_light.week, year: @high_light.year }
    assert_redirected_to high_light_path(assigns(:high_light))
  end

  test "should destroy high_light" do
    assert_difference('HighLight.count', -1) do
      delete :destroy, id: @high_light
    end

    assert_redirected_to high_lights_path
  end
end
