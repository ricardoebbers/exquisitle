defmodule FrontendWeb.ExquisitleController do
  use FrontendWeb, :controller

  def index(conn, _params) do
    game = Exquisitle.start_game(:easy)
    tally = Exquisitle.tally(game)

    conn
    |> put_session(:game, game)
    |> put_flash(:info, tally.feedback_message)
    |> render("game.html", tally: tally)
  end

  def update(conn, %{"make_move" => %{"guess" => guess}}) do
    conn.params["make_move"]["guess"]
    |> put_in("")
    |> get_session(:game)
    |> Exquisitle.make_move(guess)

    redirect(conn, to: Routes.exquisitle_path(conn, :show))
  end

  def show(conn, _params) do
    tally =
      conn
      |> get_session(:game)
      |> Exquisitle.tally()

    flash_type =
      if(tally.game_state == :bad_guess) do
        :error
      else
        :info
      end

    conn
    |> put_flash(flash_type, tally.feedback_message)
    |> render("game.html", tally: tally)
  end
end
