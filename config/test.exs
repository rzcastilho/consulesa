import Config

config :do_it, DoIt.Commfig,
  dirname: System.tmp_dir(),
  filename: "consulesa_#{ExUnit.configuration()[:seed]}.json"
