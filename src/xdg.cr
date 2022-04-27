# XDG standard values
require "./helpers"

module XDG
  module DATA
    HOME = (envpath? "XDG_DATA_HOME") || Path.home / ".local" / "share"
    DIRS = (env_list_of_paths? "XDG_DATA_DIRS") || [Path["/usr/local/share/"], Path["/usr/share/"]]
  end

  module CONFIG
    HOME = (envpath? "XDG_CONFIG_HOME") || Path.home / ".config"
    DIRS = (env_list_of_paths? "XDG_CONFIG_DIRS") || [Path["/etc/xdg"]]
  end

  module CACHE
    HOME = (envpath? "XDG_CACHE_HOME") || Path.home / ".cache"
  end

  module RUNTIME
    DIR = envpath? "XDG_RUNTIME_DIR"
  end

  module STATE
    HOME = (envpath? "XDG_STATE_HOME") || Path.home / ".local" / "state"
  end
end

private def envpath?(name) : Path?
  if set = ENV[name]?
    return if set.empty?
    Path.new set
  end
end

private def env_list_of_paths?(name) : Array(Path)?
  if (paths = ENV[name]?) && !paths.empty?
    paths.split(':').map &->Path.new(String)
  end
end
