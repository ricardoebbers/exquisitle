defmodule FrontendWeb.ExquisitleController do
  use FrontendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    game = Exquisitle.start_game(:easy)
    tally = Exquisitle.tally(game)
    conn = put_session(conn, :game, game)
    render(conn, "game.html", tally: tally)
  end

  def update(conn, %{"make_move" => %{"guess" => guess}}) do
    tally =
      conn
      |> get_session(:game)
      |> Exquisitle.make_move(guess)

    conn
    |> put_in(conn.params["make_move"]["guess"], "")
    |> render("game.html", tally: tally)
  end
end
