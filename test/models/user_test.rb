require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.create(name: 'Mbele Lebohang', email: 'dineomartins@lesotho.com',
                        password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "       "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "s" * 52
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "d" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid emails" do
    invalid_addresses = %w[dineo@email,com mbele_at_foo.org lebohang@mail. mbele@foo_bar.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email  = duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emails saved in lowercase" do
    mixed_case_email = "MbeLeMArtiNs@eMail.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  test "users without password should not be valid" do
    foo_user = User.create(name: 'Mbele Lebohang', email: 'dinns@lesotho.com')
    foo_user.save
    assert_not foo_user.valid?
  end
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
