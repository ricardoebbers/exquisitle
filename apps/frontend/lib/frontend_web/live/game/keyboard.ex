defmodule FrontendWeb.Live.Game.Keyboard do
  use FrontendWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def color_letters(tally, letter) do
    cond do
      letter in tally.correct_letters -> "correct"
      letter in tally.present_letters -> "present"
      letter in tally.absent_letters -> "absent"
      true -> ""
    end
  end
end
