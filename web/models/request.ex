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
end
