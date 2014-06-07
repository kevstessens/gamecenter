require 'test_helper'

class GameOwnersControllerTest < ActionController::TestCase
  setup do
    @game_owner = game_owners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_owners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_owner" do
    assert_difference('GameOwner.count') do
      post :create, game_owner: { email: @game_owner.email, game_id: @game_owner.game_id, password: @game_owner.password }
    end

    assert_redirected_to game_owner_path(assigns(:game_owner))
  end

  test "should show game_owner" do
    get :show, id: @game_owner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_owner
    assert_response :success
  end

  test "should update game_owner" do
    patch :update, id: @game_owner, game_owner: { email: @game_owner.email, game_id: @game_owner.game_id, password: @game_owner.password }
    assert_redirected_to game_owner_path(assigns(:game_owner))
  end

  test "should destroy game_owner" do
    assert_difference('GameOwner.count', -1) do
      delete :destroy, id: @game_owner
    end

    assert_redirected_to game_owners_path
  end
end
