defmodule BirdAppUi.DB do
  require Logger

  @page_size 10

  def child_spec(_) do
    %{
      id: __MODULE__,
      start:
        {CubDB, :start_link,
         [
           Application.get_env(:bird_app_ui, :entries_db_location),
           [name: __MODULE__, auto_compact: true]
         ]}
    }
  end

  def put_entry(message, snap) do
    if is_nil(last_entry()) || seconds_passed?(60) do
      timestamp = NaiveDateTime.to_iso8601(NaiveDateTime.utc_now())
      entry = BirdAppHardware.Dht.read(Dht4) |> Map.merge(%{message: message, snap: snap})

      CubDB.put(__MODULE__, timestamp, entry)
      |> broadcast(:new_entry)
    else
      {:error, "Sorry, only one snap per minute is allowed!"}
    end
  end

  def get_entry(key) do
    CubDB.get(__MODULE__, key)
  end

  def entries() do
    {:ok, entries} =
      CubDB.select(__MODULE__, min_key: nil, max_key: "all", reverse: true, pipe: [take: 10])

    entries
  end

  def paginate(page) when page >= 1 do
    {:ok, entries} =
      CubDB.select(__MODULE__,
        min_key: nil,
        max_key: "all",
        reverse: true,
        pipe: [
          drop: (page - 1) * @page_size,
          take: 10
        ]
      )

    entries
  end

  def last_entry() do
    {:ok, entries} =
      CubDB.select(__MODULE__, min_key: nil, max_key: "all", reverse: true, pipe: [take: 1])

    List.first(entries)
  end

  def entries_count do
    CubDB.size(__MODULE__)
  end

  def pages_count do
    ceil(entries_count() / @page_size)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(BirdAppUi.PubSub, "db")
  end

  defp broadcast(:ok, event) do
    Phoenix.PubSub.broadcast(BirdAppUi.PubSub, "db", {event, entries_count(), last_entry()})
  end

  defp seconds_passed?(seconds) do
    timestamp_last_entry = NaiveDateTime.from_iso8601!(elem(last_entry(), 0))

    if NaiveDateTime.diff(NaiveDateTime.utc_now(), timestamp_last_entry) >= seconds,
      do: true,
      else: false
  end
end
