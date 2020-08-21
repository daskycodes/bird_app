defmodule BirdAppUi.DB do

  require Logger

  def child_spec(_) do
    %{id: __MODULE__, start: {CubDB, :start_link, [Application.get_env(:bird_app_ui, :entries_db_location, "data/entries"), [auto_file_sync: true, auto_compact: true], [name: __MODULE__]]}}
  end

  def put_entry(entry = %{}) do
    Logger.debug("Putting entry `#{inspect(entry)}`.")
    CubDB.put(__MODULE__, entry.timestamp, entry)
    |> broadcast(:new_entry)
  end

  def entries do
    CubDB.size(__MODULE__)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(BirdAppUi.PubSub, "db")
  end

  defp broadcast(:ok, event) do
    Phoenix.PubSub.broadcast(BirdAppUi.PubSub, "db", {event, entries()})
    :ok
  end
end
