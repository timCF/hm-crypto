defmodule HmCrypto.Bench.Helper do
  defmacro generate_benchmarks do

    payloads =
      [1, 100, 100000]
      |> Enum.reduce(%{}, fn(bytes, acc) ->
        Map.put(acc, bytes, :crypto.strong_rand_bytes(bytes))
      end)

    private_keys =
      [1024, 2048]
      |> Enum.reduce(%{}, fn(bits, acc) ->
        key =
          "#{:code.priv_dir :hm_crypto}/#{bits}"
          |> File.read!
          |> HmCrypto.PublicKey.parse_pem
          |> Macro.escape
        Map.put(acc, bits, key)
      end)

    HmCrypto.rsa_digest_types
    |> Enum.reduce(quote do end, fn(digest_type, acc) ->
        Enum.reduce(private_keys, acc, fn({key_bits_qty, key}, acc) ->
          Enum.reduce(payloads, acc, fn({payload_bytes_qty, payload}, acc) ->
            quote do
              unquote(acc)
              bench unquote("#{digest_type |> Atom.to_string}/#{key_bits_qty}-bits-key/#{payload_bytes_qty}-bytes-payload") do
                HmCrypto.sign!(unquote(payload),
                               unquote(digest_type),
                               unquote(key))
              end
            end
          end)
        end)
    end)
  end
end
