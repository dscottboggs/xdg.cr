# xdg

Constants representing the XDG config locations or their standard defaults if not set.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     xdg:
       github: dscottboggs/xdg.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "xdg"

File.open XDG.config_file("myapp") / "config.yml", mode: "w" do |config|
  myapp_config.to_yaml config
end
```
