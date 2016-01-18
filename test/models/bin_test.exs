defmodule RequestBin.BinTest do
  use RequestBin.ModelCase

  alias RequestBin.Bin

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bin.changeset(%Bin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "name is generated on insert" do
    changeset = Bin.changeset(%Bin{}, %{})
    {:ok, bin} = RequestBin.Repo.insert(changeset)
    assert String.length(bin.name) > 0
  end
end
