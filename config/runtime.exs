import Config

config :do_it, DoIt.Commfig,
  dirname: Path.join(System.user_home!(), ".consulesa"),
  filename: "consulesa.json"
