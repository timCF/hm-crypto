defmodule HmCrypto.SignBench do
  use Benchfella
  import HmCrypto.Bench.Helper
  generate_benchmarks(
    fn(%HmCrypto.Bench.Helper{payloads: payloads, private_keys: private_keys}) ->
      HmCrypto.rsa_digest_types
      |> Enum.reduce(quote do end, fn(digest_type, acc) ->
          Enum.reduce(private_keys, acc, fn({key_bits_qty, key}, acc) ->
            Enum.reduce(payloads, acc, fn({payload_bytes_qty, payload}, acc) ->
              quote do
                unquote(acc)
                bench unquote("sign #{digest_type}/#{key_bits_qty}-bits-key/#{payload_bytes_qty}-bytes-payload") do
                  HmCrypto.sign!(unquote(payload),
                                 unquote(digest_type),
                                 unquote(key))
                end
              end
            end)
          end)
      end)
    end)
end
