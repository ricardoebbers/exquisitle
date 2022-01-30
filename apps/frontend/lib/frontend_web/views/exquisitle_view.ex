defmodule FrontendWeb.ExquisitleView do
  use FrontendWeb, :view

  def colored_letter(letter, hint) do
    "<div class='letter #{hint}'>#{letter}</div>"
  end
end
