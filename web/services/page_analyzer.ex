defmodule FourOhFourFinderApp.PageAnalyzer do
  require Logger
  use HTTPoison.Base

  def analyze(url) do
    case get_with_redirects(url) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        dom_tree = Exquery.tree(body)
        if good_resp?(code) do
          %{
            url: url,
            http_status: code,
            success: true,
            outgoing_hrefs: tree_hrefs(dom_tree),
            anchors: tree_ids(dom_tree)
          }
        else
          %{ url: url, http_status: code, success: false }
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{
          url: url,
          error: reason
        }
    end
  end


  def get_with_redirects(url) do
    case get(url) do
      {:ok, response} ->
        if redirect?(response.status_code) do
          get_with_redirects(redirect_location(response.headers))
        else
          {:ok, response}
        end

      {:error, response} ->
        {:error, response}
    end
  end

  def redirect_location(headers) do
    elem(Enum.find(headers, fn({header, val}) -> "Location" == header end), 1)
  end

  def good_resp?(code) do
    code >= 200 && code < 300
  end

  def redirect?(code) do
    code >= 300 && code < 400
  end

  def tree_hrefs(tree) do
    Exquery.Query.all(tree, {:tag, "a", []})
    |> Enum.map( fn(node) -> node_attr(node, "href") end)
    |> Enum.filter( fn(val) -> nil != val end)
  end

  def tree_ids(tree) do
    Exquery.Query.all(tree, {:tag, :any, []})
    |> Enum.map( fn(node) -> node_attr(node, "id") end)
    |> Enum.filter( fn(val) -> nil != val end)
  end

  def node_attr(node, attr) do
    attrs = case node do
      {_, _, attrs} -> attrs
      {{_, _, attrs}, _} -> attrs
    end
    attr = Enum.find(attrs, fn({name, val}) -> name == attr end)
    if attr do
      elem(attr, 1)
    else
      nil
    end
  end
end
