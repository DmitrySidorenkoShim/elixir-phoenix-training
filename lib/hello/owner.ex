defmodule Hello.Owner do
  use Ecto.Schema
  import Ecto.Changeset

  schema "owners" do
    field :bio, :string
    field :email, :string
    field :name, :string
    field :number_of_pets, :integer

    timestamps()
  end

  @doc false
  def changeset(owner, attrs) do
    owner
    |> cast(attrs, [:name, :email, :bio, :number_of_pets])
    |> validate_required([:name, :email, :bio])
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
  end
end
