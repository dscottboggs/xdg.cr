module XDG
  extend self

  # The path to the named data file if it exists in any of `XDG::DATA::HOME`
  # ($XDG_DATA_DIRS) or `XDG::DATA::DIRS` ($XDG_DATA_DIRS).
  def data_file(name : Path | String) : Path?
    ([DATA::HOME] | DATA::DIRS).find do |dir|
      File.exists? dir / name
    end.try &./ name
  end

  # The path to the named config file if it exists in any of `XDG::CONFIG::HOME`
  # ($XDG_CONFIG_DIRS) or `XDG::CONFIG::DIRS` ($XDG_CONFIG_DIRS).
  def config_file(name : Path | String) : Path?
    ([CONFIG::HOME] | CONFIG::DIRS).find do |dir|
      File.exists? dir / name
    end.try &./ name
  end

  # The path to the named state file if it exists in `XDG::STATE::HOME` ($XDG_STATE_HOME)
  def state_file(name : Path | String) : Path?
    full_path = STATE::HOME / name
    full_path if File.exists? full_path
  end

  # The path to the named state file if it exists in `XDG::CACHE::HOME` ($XDG_CACHE_HOME)
  def cache_file(name : Path | String) : Path?
    full_path = CACHE::HOME / name
    full_path if File.exists? full_path
  end


  # Open a data file for appending if it exists in any of $XDG_DATA_HOME or
  # $XDG_DATA_DIRS, otherwise create it. Reads happen from the beggining of
  # the file.
  def data_file(name : Path | String, *, binary = false, mode = nil, & : File -> T) : T forall T
    path = (data_file name) || DATA::HOME / name
    File.open path, mode: mode || "a#{'b' if binary}+" do |file|
      yield file
    end
  end

  # Open a config file for appending if it exists in any of $XDG_CONFIG_HOME or
  # $XDG_CONFIG_DIRS, otherwise create it. Reads happen from the beggining of
  # the file.
  def config_file(name : Path | String, *, binary = false, mode = nil, & : File -> T) : T forall T
    path = (config_file name) || CONFIG::HOME / name
    File.open path, mode: mode || "a#{'b' if binary}+" do |file|
      yield file
    end
  end

  # Open a state file if it exists in $XDG_STATE_HOME, otherwise create it.
  # Reads happen from the beggining of the file.
  def state_file(name : Path | String, *, binary = false, mode = nil, & : File -> T) : T forall T
    File.open STATE::HOME / name, mode: mode || "a#{'b' if binary}+" do |file|
      yield file
    end
  end

  def cache_file(name : Path | String, *, binary = false, mode = nil, & : File -> T) forall T
    File.open CACHE::HOME / name, mode: mode || "a#{'b' if binary}+" do |file|
      yield file
    end
  end
end
