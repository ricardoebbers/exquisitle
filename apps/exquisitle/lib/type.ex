defmodule Exquisitle.Type do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.{Guess, Hints, Tally}

  @type game :: Game.t()
  @type guess :: Guess.t()
  @type hints :: Hints.t()
  @type state :: :initialized | :good_guess | :bad_guess | :won
  @type tally :: Tally.t()
end
