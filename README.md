# XyImg

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `xy_img` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:xy_img, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/xy_img](https://hexdocs.pm/xy_img).

Configuration
-------------
To configure lager's backends, you use an application variable (probably in
your app.config):

```elixir
config :xy_img,
  phx_name: :im_webserver, #phoenix应用名称
  path: "lbt", #图片存放更目录 priv/static/images/lbt,默认priv/static/images/xy_img
  expires: 60_000 #图片存在时长（s) nil:永久存在
```