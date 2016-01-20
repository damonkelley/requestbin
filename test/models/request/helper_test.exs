defmodule RequestBin.Request.HelperTest do
  use RequestBin.ModelCase
  use Plug.Test

  alias RequestBin.Request

  test "struct created from connection" do
    conn = conn(:get, "/", "Test body")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept-encoding", "gzip, deflate")

    conn = %{conn | remote_ip: {192, 168, 0 , 1}}

    request = Request.Helper.from_conn(%Request{}, conn)

    assert request.method == "GET"
    assert request.remote_ip == "192.168.0.1"
    assert request.body == "Test body"
    assert request.headers == %{"content-type" => "application/json",
                                "accept-encoding" => "gzip, deflate"}
  end

  test "method added to struct" do
    conn = conn(:put, "/")
    request = Request.Helper.put_method(%Request{}, conn)

    assert request.method == "PUT"
  end

  test "headers added to struct" do
    conn = conn(:get, "/")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept-encoding", "gzip, deflate")
    request = Request.Helper.put_headers(%Request{}, conn)

    assert request.headers == %{"content-type" => "application/json",
                                "accept-encoding" => "gzip, deflate"}
  end

  test "body added to struct" do
    conn = conn(:get, "/", "Test body")
    request = Request.Helper.put_body(%Request{}, conn)
    assert request.body == "Test body"
  end

  test "remote ip added to struct" do
    conn = conn(:get, "/")
    conn = %{conn | remote_ip: {192, 168, 0 , 1}}
    request = Request.Helper.put_remote_ip(%Request{}, conn)

    assert request.remote_ip == "192.168.0.1"
  end
end
