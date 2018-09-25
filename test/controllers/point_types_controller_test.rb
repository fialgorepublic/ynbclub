require 'test_helper'

class PointTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @point_type = point_types(:one)
  end

  test "should get index" do
    get point_types_url
    assert_response :success
  end

  test "should get new" do
    get new_point_type_url
    assert_response :success
  end

  test "should create point_type" do
    assert_difference('PointType.count') do
      post point_types_url, params: { point_type: { name: @point_type.name, point: @point_type.point } }
    end

    assert_redirected_to point_type_url(PointType.last)
  end

  test "should show point_type" do
    get point_type_url(@point_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_point_type_url(@point_type)
    assert_response :success
  end

  test "should update point_type" do
    patch point_type_url(@point_type), params: { point_type: { name: @point_type.name, point: @point_type.point } }
    assert_redirected_to point_type_url(@point_type)
  end

  test "should destroy point_type" do
    assert_difference('PointType.count', -1) do
      delete point_type_url(@point_type)
    end

    assert_redirected_to point_types_url
  end
end
