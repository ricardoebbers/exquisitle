defmodule FrontendWeb.Live.Game.Board do
  use FrontendWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def animate_input(guess, index) do
    if length(guess) > index do
      "animation: 0.25s linear 0s 1 normal forwards running popup;"
    end
  end

  def animate_bad_guess(tally) do
    if tally.game_state == :bad_guess do
      "animation: 0.75s ease-in-out 0s 1 normal none running rownope;"
    end
  end
end
