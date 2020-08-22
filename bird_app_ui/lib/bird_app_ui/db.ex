defmodule BirdAppUi.DB do

  require Logger

  def child_spec(_) do
    %{id: __MODULE__, start: {CubDB, :start_link, [Application.get_env(:bird_app_ui, :entries_db_location), [name: __MODULE__]]}}
  end

  def put_entry() do
    entry = BirdAppHardware.Dht.read(Dht4)
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_iso8601()
    Logger.debug("Putting entry `#{inspect(entry)}`.")
    CubDB.put(__MODULE__, timestamp, entry)
    |> broadcast(:new_entry)
  end

  def entries_count do
    CubDB.size(__MODULE__)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(BirdAppUi.PubSub, "db")
  end

  defp broadcast(:ok, event) do
    Phoenix.PubSub.broadcast(BirdAppUi.PubSub, "db", {event, entries_count()})
    :ok
  end
end
