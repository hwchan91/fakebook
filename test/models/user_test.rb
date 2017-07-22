require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @michael = users(:michael)
    @archer = users(:archer)
  end

  test "should friend and unfriend a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.friend?(archer)
    assert_not archer.friend?(michael)

    michael.friend_request(archer)
    assert michael.pending_request?(archer)
    assert archer.awaiting_confirm?(michael)
    assert_not michael.friend?(archer)
    assert_not archer.friend?(michael)

    archer.confirm_request(michael)
    assert michael.friend?(archer)
    assert archer.friend?(michael)

    michael.unfriend(archer)
    assert_not michael.friend?(archer)
    assert_not archer.friend?(michael)
    assert_not michael.pending_request?(archer)
    assert_not archer.awaiting_confirm?(michael)
  end

  test "should not allow duplicates" do
    @michael.friend(@archer)
    duplicate = Friendship.new(user_id: @michael.id, friend_id: @archer.id)
    assert_not duplicate.valid?
    duplicate = Friendship.new(user_id: @archer.id, friend_id: @michael.id)
    assert_not duplicate.valid?
  end

  test "should destroy friendship if user is destroyed" do
    @michael.friend(@archer)
    assert_difference 'Friendship.count', -2 do
      @michael.destroy
    end
  end
end
