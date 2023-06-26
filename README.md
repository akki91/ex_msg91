# ExMsg91
**Elixir library for Msg91**

## Installation

the package can be installed by adding `ex_msg91` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_msg91, "~> 0.1.0"}
  ]
end
```

## Configuration
```elixir
config :ex_msg,
  authkey: "msg91_api_key",
```

## Usage

```elixir

ExMsg91.send_sms("123123", "1234567890", "91", %{"var1" => "123456"})
{200, %{"message" => "33667a74764c323230353034", "type" => "success"}}

##Parameters

send_sms(template_id, phone_number, country_code, variables)
1) `template_id` - Template ID of SMS template in Msg91
2) `phone_number` - Phone number without country code
3) `country_code` - Country code without + sign (E.g. For India use 91)
4) `variable` - Map of variables present in template.
```