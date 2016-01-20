defmodule RequestBin.RequestTest do
  use RequestBin.ModelCase
  use Plug.Test

  alias RequestBin.Request

  @valid_attrs %{method: "GET", body: "Test Body", headers: %{"Accept" => "*"}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Request.changeset(%Request{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Request.changeset(%Request{}, @invalid_attrs)
    refute changeset.valid?
  end
end
