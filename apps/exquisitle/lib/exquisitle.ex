defmodule Exquisitle do
  alias Exquisitle.Impl.Game

  defdelegate new_game, to: Game, as: :new

  def make_guess do
  end
end
