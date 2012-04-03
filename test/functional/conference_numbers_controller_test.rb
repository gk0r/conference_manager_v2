require 'test_helper'

class ConferenceNumbersControllerTest < ActionController::TestCase
  setup do
    @conference_number = conference_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conference_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conference_number" do
    assert_difference('ConferenceNumber.count') do
      post :create, conference_number: @conference_number.attributes
    end

    assert_redirected_to conference_number_path(assigns(:conference_number))
  end

  test "should show conference_number" do
    get :show, id: @conference_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conference_number
    assert_response :success
  end

  test "should update conference_number" do
    put :update, id: @conference_number, conference_number: @conference_number.attributes
    assert_redirected_to conference_number_path(assigns(:conference_number))
  end

  test "should destroy conference_number" do
    assert_difference('ConferenceNumber.count', -1) do
      delete :destroy, id: @conference_number
    end

    assert_redirected_to conference_numbers_path
  end
end
