defmodule RequestBin.BinControllerTest do
  use RequestBin.ConnCase

  alias RequestBin.Repo
  alias RequestBin.Bin

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "$ cp RequestBin"
  end

  test "POST /", %{conn: conn} do
    conn = post conn, "/"
    [bin | _] = Repo.all(RequestBin.Bin)
    assert redirected_to(conn) == bin_path(conn, :show, bin.name, inspect: true)
  end

  test "Get /:name?inspect=true shows requests", %{conn: conn} do
    bin = Repo.insert!(%Bin{})

    Enum.each(1..2, fn(_) ->
      request = build_assoc(bin, :requests)
      Repo.insert!(%{request | method: "GET"})
    end)

    # Add some other requests to make sure only the requests from the 
    # requested bin are retrieved.
    other_bin = Repo.insert!(%Bin{})
    request = build_assoc(other_bin, :requests)
    Repo.insert!(%{request |method: "GET"})

    conn = get conn, bin_path(conn, :show, bin.name, inspect: true)
    assert html_response(conn, 200) =~ "2 Requests"
  end

  test "GET /:name?inspect=true with invalid key is 404" do
    key = :crypto.strong_rand_bytes(10) |> Base.encode16(case: :lower)

    assert_raise Ecto.NoResultsError, fn ->
      get conn, bin_path(conn, :show, key)
    end 

    {_, _, body} = assert_error_sent 404, fn ->
      get conn, bin_path(conn, :show, key, inspect: true)
    end

    assert body =~ "not found"
  end

  test "GET /:name with invalid key is 404" do
    key = :crypto.strong_rand_bytes(10) |> Base.encode16(case: :lower)

    assert_raise Ecto.NoResultsError, fn ->
      get conn, bin_path(conn, :show, key)
    end 

    {_, _, body} = assert_error_sent 404, fn ->
      get conn, bin_path(conn, :show, key)
    end

    assert body =~ "not found"
  end

  test "Any method to bin gets 'ok'", %{conn: _conn} do
    methods = [:get, :options, :patch, :post, :put, :delete, :connect, :trace]
    bin = Repo.insert!(%Bin{})

    Enum.each(methods, fn (method) -> 
      conn = conn()
      conn = dispatch(conn, @endpoint, method, bin_path(conn, :show, bin.name))
      assert text_response(conn, 200) =~ "ok", "Did not match with method #{method}"
    end)

    # Do separate check for HEAD because it will not contain any body content.
    conn = conn()
    conn = head conn, bin_path(conn, :show, bin.name)
    assert response(conn, 200)
  end

  test "Show saves request details" do
    bin = Repo.insert!(%Bin{})
    conn = get conn, bin_path(conn, :show, bin.name)
    bin = Repo.preload bin, :requests

    assert Enum.count(bin.requests) == 1
  end
end
