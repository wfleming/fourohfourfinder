defmodule FourOhFourFinderApp.Api.PageController do
  use FourOhFourFinderApp.Web, :controller

  def fetch(conn, params) do
    page_info = FourOhFourFinderApp.PageAnalyzer.analyze(params["url"])
    render conn, page: page_info
  end
end
