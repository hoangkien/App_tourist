require 'test_helper'

class TourguidesControllerTest < ActionController::TestCase
  setup do
    @tourguide = tourguides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tourguides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tourguide" do
    assert_difference('Tourguide.count') do
      post :create, tourguide: { active: @tourguide.active, address: @tourguide.address, device_id: @tourguide.device_id, name: @tourguide.name, phone: @tourguide.phone }
    end

    assert_redirected_to tourguide_path(assigns(:tourguide))
  end

  test "should show tourguide" do
    get :show, id: @tourguide
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tourguide
    assert_response :success
  end

  test "should update tourguide" do
    patch :update, id: @tourguide, tourguide: { active: @tourguide.active, address: @tourguide.address, device_id: @tourguide.device_id, name: @tourguide.name, phone: @tourguide.phone }
    assert_redirected_to tourguide_path(assigns(:tourguide))
  end

  test "should destroy tourguide" do
    assert_difference('Tourguide.count', -1) do
      delete :destroy, id: @tourguide
    end

    assert_redirected_to tourguides_path
  end
end
