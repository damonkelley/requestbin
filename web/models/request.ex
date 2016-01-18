defmodule RequestBin.Request do
  use RequestBin.Web, :model
  use Ecto.Model.Callbacks

  schema "requests" do
    field :method
    field :headers, :map
    field :body, :binary
    field :remote_ip
    belongs_to :bin, RequestBin.Bin

    timestamps
  end

  @required_fields ~w(method)
  @optional_fields ~w(headers body remote_ip)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def put_method(model, conn) do
    %{model | method: conn.method}
  end

  def put_headers(model, conn) do
    %{model | headers: Enum.into(conn.req_headers, %{})}
  end

  def put_body(model, conn) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    %{model | body: body}
  end

  def put_remote_ip(model, conn) do
    remote_ip = Tuple.to_list(conn.remote_ip) |> Enum.join(".")

    %{model | remote_ip: remote_ip}
  end

  def from_conn(model, conn) do
    model
    |> put_headers(conn)
    |> put_body(conn)
    |> put_remote_ip(conn)
    |> put_method(conn)
  end
end
