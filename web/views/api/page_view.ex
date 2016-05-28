defmodule FourOhFourFinderApp.Api.PageView do
  use FourOhFourFinderApp.Web, :view

  def render("fetch.json", %{page: page}) do
    page
  end
end
