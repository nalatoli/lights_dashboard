defmodule LightsDashboardWeb.LightControllerTest do
  use LightsDashboardWeb.ConnCase

  import LightsDashboard.LightsFixtures

  alias LightsDashboard.Lights.Light

  @create_attrs %{
    name: "some name",
    state: true,
    mac_address: "some mac_address"
  }
  @update_attrs %{
    name: "some updated name",
    state: false,
    mac_address: "some updated mac_address"
  }
  @invalid_attrs %{name: nil, state: nil, mac_address: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lights", %{conn: conn} do
      conn = get(conn, ~p"/api")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create light" do
    test "renders light when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api", light: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/#{id}")

      assert %{
               "id" => ^id,
               "mac_address" => "some mac_address",
               "name" => "some name",
               "state" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/", light: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update light" do
    setup [:create_light]

    test "renders light when data is valid", %{conn: conn, light: %Light{id: id} = light} do
      conn = put(conn, ~p"/api/#{light}", light: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/#{id}")

      assert %{
               "id" => ^id,
               "mac_address" => "some updated mac_address",
               "name" => "some updated name",
               "state" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, light: light} do
      conn = put(conn, ~p"/api/#{light}", light: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete light" do
    setup [:create_light]

    test "deletes chosen light", %{conn: conn, light: light} do
      conn = delete(conn, ~p"/api/#{light}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/#{light}")
      end
    end
  end

  defp create_light(_) do
    light = light_fixture()
    %{light: light}
  end
end
