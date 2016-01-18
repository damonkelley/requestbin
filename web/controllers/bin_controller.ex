defmodule RequestBin.BinController do
  use RequestBin.Web, :controller

  alias RequestBin.{Bin, Request}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    changeset = Bin.changeset(%Bin{}, %{})

    {:ok, bin} = Repo.insert(changeset)
    redirect conn, to: bin_path(conn, :show, bin.name, inspect: true)
  end

  def show(%Plug.Conn{method: "GET"} = conn, %{"name" => name, "inspect" => "true"}) do
    bin = Bin
    |> Bin.with_requests
    |> Repo.get_by(name: name)

    conn = assign(conn, :bin, bin)
    render conn, "show.html"
  end

  def show(conn, %{"name" => name}) do
    Repo.get_by(Bin, name: name)
    |> build_assoc(:requests)
    |> Request.from_conn(conn)
    |> Repo.insert!

    text conn, "ok"
  end
end
