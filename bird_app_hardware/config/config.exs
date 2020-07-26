use Mix.Config

config :picam, camera: Picam.FakeCamera

config :logger,
  level: :debug,
  utc_log: true

config :logger, :console,
  level: :debug,
  format: "$dateT$time [$level] $message\n"
