defmodule RequestBin.Bin do
  use RequestBin.Web, :model
  use Ecto.Model.Callbacks

  before_insert :generate_name

  schema "bins" do
    field :name, :string
    has_many :requests, RequestBin.Request

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def generate_name(changeset) do
    name = :crypto.strong_rand_bytes(10)
      |> Base.encode16(case: :lower)

    put_change(changeset, :name, name)
  end

  def with_requests(query) do
    from q in query, preload: [:requests]
  end
end
