defmodule LightsDashboardWeb.LightLiveTest do
  use LightsDashboardWeb.ConnCase

  import Phoenix.LiveViewTest
  import LightsDashboard.LightsFixtures

  @create_attrs %{name: "some name", state: true, mac_address: "some mac_address"}
  @update_attrs %{
    name: "some updated name",
    state: false,
    mac_address: "some updated mac_address"
  }
  @invalid_attrs %{name: nil, state: false, mac_address: nil}

  defp create_light(_) do
    light = light_fixture()
    %{light: light}
  end

  describe "Index" do
    setup [:create_light]

    test "lists all lights", %{conn: conn, light: light} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboard")

      assert html =~ "Lights Dashboard"
      assert html =~ light.name
    end

    test "saves new light", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboard")

      assert index_live |> element("a", "New Light") |> render_click() =~
               "New Light"

      assert_patch(index_live, ~p"/dashboard/new")

      assert index_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#light-form", light: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboard")

      html = render(index_live)
      assert html =~ "Light created successfully"
      assert html =~ "some name"
    end

    test "updates light in listing", %{conn: conn, light: light} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboard")

      assert index_live |> element("#lights-#{light.id} a", "Edit") |> render_click() =~
               "Edit Light"

      assert_patch(index_live, ~p"/dashboard/#{light}/edit")

      assert index_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#light-form", light: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboard")

      html = render(index_live)
      assert html =~ "Light updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes light in listing", %{conn: conn, light: light} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboard")

      assert index_live |> element("#lights-#{light.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lights-#{light.id}")
    end
  end

  describe "Show" do
    setup [:create_light]

    test "displays light", %{conn: conn, light: light} do
      {:ok, _show_live, html} = live(conn, ~p"/dashboard/#{light}")

      assert html =~ "Show Light"
      assert html =~ light.name
    end

    test "updates light within modal", %{conn: conn, light: light} do
      {:ok, show_live, _html} = live(conn, ~p"/dashboard/#{light}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Light"

      assert_patch(show_live, ~p"/dashboard/#{light}/show/edit")

      assert show_live
             |> form("#light-form", light: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#light-form", light: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/dashboard/#{light}")

      html = render(show_live)
      assert html =~ "Light updated successfully"
      assert html =~ "some updated name"
    end
  end
end
