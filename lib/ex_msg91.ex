defmodule ExMsg91 do
  @moduledoc """
  Documentation for `ExMsg91` Elixir library for MSG91.
  https://msg91.com/
  """

  @msg_91_headers %{
    "content-type" => "application/json",
    "accept" => "application/json"
  }

  def sms_url, do: "https://control.msg91.com/api/v5/flow/"

  @doc """
  Method to send SMS to a phone number.

  Returns
  `{200, %{"message" => "33667a74764c323230353034", "type" => "success"}}`
  `{418, %{"message" => "IP not whitelisted", "type" => "unauthorised"}}`



  ## Examples

        ExMsg91.send_sms("123123", "1234567890", "91", %{"var1" => "123456"})
        {200, %{"message" => "33667a74764c323230353034", "type" => "success"}}

        Parameters

        send_sms(template_id, phone_number, country_code, variables)

        1) `template_id` - Template ID of SMS template in Msg91
        2) `phone_number` - Phone number without country code
        3) `country_code` - Country code without + sign (E.g. For India use 91)
        4) `variable` - Map of variables present in template.

  """

  def send_sms(template_id, phone_number, country_code, variables \\ %{}) do
    authkey = from_env(:ex_msg91, :auth_key)
    processed_phone = String.trim(country_code <> phone_number)
    params = build_params(processed_phone, template_id, variables)
    {status_code, processed_response} = perform(:post, sms_url(), params, %{"authkey" => authkey})
    {status_code, processed_response}
  end

  defp build_params(processed_phone, template_id, variables) do
    Map.merge(
      %{
        "template_id" => template_id,
        "mobiles" => processed_phone
      },
      variables
    )
  end

  defp from_env(otp_app, key, default \\ nil)

  defp from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value

  defp perform(
         request_type,
         url,
         params \\ %{},
         headers \\ %{},
         options \\ []
       ) do
    headers = Map.merge(@msg_91_headers, headers) |> Enum.map(& &1)
    response = HTTPoison.request(request_type, url, Jason.encode!(params), headers, options)
    {status_code, processed_response} = process_response(response)
    {status_code, processed_response}
  end

  defp process_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}}
      when status_code in 200..499 ->
        {status_code, parse_response(headers, body)}

      {_, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}}
      when status_code in 500..599 ->
        {status_code, parse_response(headers, body)}

      {:error, %HTTPoison.Error{id: _id, reason: reason}} ->
        {500, reason}
    end
  end

  defp parse_response(headers, body) do
    content_type =
      (List.keyfind(headers, "Content-Type", 0) || List.keyfind(headers, "content-type", 0))
      |> fetch_content_type()

    if String.match?(content_type, ~r/^application\/.*json$/), do: Jason.decode!(body), else: body
  end

  defp fetch_content_type(nil), do: nil

  defp fetch_content_type({"Content-Type", content_type_with_encoding}) do
    [content_type | _] = String.split(content_type_with_encoding, ";")
    content_type
  end

  defp fetch_content_type({"content-type", content_type_with_encoding}) do
    [content_type | _] = String.split(content_type_with_encoding, ";")
    content_type
  end
end
