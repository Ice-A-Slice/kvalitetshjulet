require 'test_helper'

/Testerna show, edit, update och destroy fungerade inte efter deras standard scaffold.
Man måste skicka med dem ett bestämt id att arbeta med.
Anledningen till att detta bara berör de namespaceade objekten vet jag inte, men så är det./

class Juror::UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get show" do
    get :show, {:id => 1}
    assert_response :success
  end

  test "should get destroy" do
    get :destroy, {:id => 1}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => 1}
    assert_response :success
  end

  test "should get update" do
    get :update, {:id => 1}
    assert_response :success
  end

end
