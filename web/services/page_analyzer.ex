defmodule FourOhFourFinderApp.PageAnalyzer do
  use HTTPoison.Base

  def analyze(url) do
    case get_with_redirects(url) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        html = Floki.parse(body)
        if good_resp?(code) do
          %{
            url: url,
            http_status: code,
            success: true,
            outgoing_hrefs: tree_hrefs(html, url),
            ids: tree_ids(html)
          }
        else
          %{ url: url, http_status: code, success: false }
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{
          url: url,
          error: reason,
          success: false
        }
    end
  end


  def get_with_redirects(url) do
    case get(url) do
      {:ok, response} ->
        if redirect?(response.status_code) do
          get_with_redirects(resolve_url(redirect_location(response.headers), url))
        else
          {:ok, response}
        end

      {:error, response} ->
        {:error, response}
    end
  end

  def redirect_location(headers) do
    elem(Enum.find(headers, fn({header, _}) -> "Location" == header end), 1)
  end

  def good_resp?(code) do
    code >= 200 && code < 300
  end

  def redirect?(code) do
    code >= 300 && code < 400
  end

  def tree_hrefs(html, url) do
    html |> Floki.find("a[href]")
      |> Enum.reject(fn(a) -> is_nil(Enum.at(Floki.attribute(a, "href"), 0)) end)
      |> Enum.filter(fn(a) -> String.length(Enum.at(Floki.attribute(a, "href"), 0)) > 0 end)
      |> Enum.map(fn(a) ->
        %{
           href: resolve_url(Enum.at(Floki.attribute(a, "href"), 0), url),
           text: Floki.text(a),
        }
      end)
  end

  def tree_ids(html) do
    html |> Floki.find("[id]") |> Floki.attribute("id")
      |> Enum.reject(&is_nil/1)
  end

  def resolve_url(target, base) do
    case URI.parse(target) do
      %{ scheme: nil } -> resolve_path_url(target, base)
      _ -> target
    end
  end

  def resolve_path_url(target, base) do
    base_uri = URI.parse(base)
    case target do
      "/" <> _ -> # absolute path on same domain
        new_uri = %{ base_uri | path: target }
        URI.to_string(new_uri)
      _ -> # relative path
        new_uri = %{ base_uri | path: String.rstrip(base_uri.path, ?/) <> "/" <> target }
        URI.to_string(base_uri)
    end
  end
end
