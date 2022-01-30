defmodule FrontendWeb.Live.Game do
  use FrontendWeb, :live_view

  @alphabet "abcdefghijklmnopqrstuvwxyz"

  @impl true
  def mount(_params, _session, socket) do
    game = Exquisitle.start_game(:easy)
    tally = Exquisitle.tally(game)

    {:ok, assign(socket, %{game: game, tally: tally, guess: []})}
  end

  @impl true
  def handle_event("type", _, socket = %{assigns: %{tally: %{game_state: :won}}}) do
    {:noreply, socket}
  end

  def handle_event("type", %{"key" => "Backspace"}, socket = %{assigns: %{guess: guess}}) do
    guess = List.delete_at(guess, length(guess) - 1)
    {:noreply, assign(socket, %{guess: guess})}
  end

  def handle_event("type", %{"key" => "⌫"}, socket = %{assigns: %{guess: guess}}) do
    guess = List.delete_at(guess, length(guess) - 1)
    {:noreply, assign(socket, %{guess: guess})}
  end

  def handle_event("type", %{"key" => "Enter"}, socket = %{assigns: %{game: game, guess: guess}}) do
    tally = Exquisitle.make_move(game, Enum.join(guess, ""))

    if tally.game_state != :bad_guess do
      {:noreply, assign(socket, %{tally: tally, guess: []})}
    else
      {:noreply, assign(socket, %{tally: tally, guess: guess})}
    end
  end

  def handle_event("type", %{"key" => key}, socket = %{assigns: %{guess: guess}}) do
    key = String.downcase(key)

    if String.contains?(@alphabet, key) && length(guess) < 5 do
      guess = guess ++ [String.downcase(key)]
      {:noreply, assign(socket, %{guess: guess})}
    else
      {:noreply, socket}
    end
  end
end
