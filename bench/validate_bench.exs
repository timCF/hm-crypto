defmodule HmCrypto.ValidateBench.SignInfo do
  defstruct [
    :payload,
    :signature,
    :digest_type,
    :public_key,
    :key_bits_qty,
    :payload_bytes_qty,
  ]
end

defmodule HmCrypto.ValidateBench do
  use Benchfella
  import HmCrypto.Bench.Helper
  generate_benchmarks(
    fn(%HmCrypto.Bench.Helper{payloads: payloads, private_keys: private_keys, public_keys: public_keys}) ->

      HmCrypto.rsa_digest_types
      |> Enum.flat_map(fn(digest_type) ->
          private_keys
          |> Enum.flat_map(fn({key_bits_qty, quoted_private_key}) ->
            {private_key, []} = Code.eval_quoted(quoted_private_key)
            payloads
            |> Enum.map(fn({payload_bytes_qty, payload}) ->
                {public_key, []} = Map.get(public_keys, key_bits_qty) |> Code.eval_quoted
                %HmCrypto.ValidateBench.SignInfo{
                  payload: payload,
                  signature: HmCrypto.sign!(payload, digest_type, private_key),
                  digest_type: digest_type,
                  public_key: public_key,
                  key_bits_qty: key_bits_qty,
                  payload_bytes_qty: payload_bytes_qty,
                }
            end)
          end)
      end)
      |> Enum.reduce(quote do end, fn(%HmCrypto.ValidateBench.SignInfo{
            payload: payload,
            signature: signature,
            digest_type: digest_type,
            public_key: public_key,
            key_bits_qty: key_bits_qty,
            payload_bytes_qty: payload_bytes_qty,
          }, acc) ->
        quote do
          unquote(acc)
          bench unquote("validate #{digest_type}/#{key_bits_qty}-bits-key/#{payload_bytes_qty}-bytes-payload") do
            true = HmCrypto.valid?(unquote(payload),
                                   unquote(signature),
                                   unquote(digest_type),
                                   unquote(public_key |> Macro.escape))
          end
        end
      end)

    end)
end
