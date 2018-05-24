require 'test_helper'

class ReferralSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @referral_sale = referral_sales(:one)
  end

  test "should get index" do
    get referral_sales_url
    assert_response :success
  end

  test "should get new" do
    get new_referral_sale_url
    assert_response :success
  end

  test "should create referral_sale" do
    assert_difference('ReferralSale.count') do
      post referral_sales_url, params: { referral_sale: { order_id: @referral_sale.order_id, user_id: @referral_sale.user_id } }
    end

    assert_redirected_to referral_sale_url(ReferralSale.last)
  end

  test "should show referral_sale" do
    get referral_sale_url(@referral_sale)
    assert_response :success
  end

  test "should get edit" do
    get edit_referral_sale_url(@referral_sale)
    assert_response :success
  end

  test "should update referral_sale" do
    patch referral_sale_url(@referral_sale), params: { referral_sale: { order_id: @referral_sale.order_id, user_id: @referral_sale.user_id } }
    assert_redirected_to referral_sale_url(@referral_sale)
  end

  test "should destroy referral_sale" do
    assert_difference('ReferralSale.count', -1) do
      delete referral_sale_url(@referral_sale)
    end

    assert_redirected_to referral_sales_url
  end
end
