defmodule PhxExWeb.StaticPlotController do
  use PhxExWeb, :controller

  @code ~S"""
  monthly = [
    %{"month" => "Jan", "sales" => 42},
    %{"month" => "Feb", "sales" => 55},
    %{"month" => "Mar", "sales" => 61},
    %{"month" => "Apr", "sales" => 48},
    %{"month" => "May", "sales" => 73}
  ]
  Plotly.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
  """

  def index(conn, _params) do
    monthly = [
      %{"month" => "Jan", "sales" => 42},
      %{"month" => "Feb", "sales" => 55},
      %{"month" => "Mar", "sales" => 61},
      %{"month" => "Apr", "sales" => 48},
      %{"month" => "May", "sales" => 73}
    ]

    figure = Plotly.bar(monthly, x: "month", y: "sales", title: "Monthly Sales")
    render(conn, :index, figure: figure, code: @code)
  end
end
