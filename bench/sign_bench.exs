defmodule HmCrypto.SignBench do
  use Benchfella
  import HmCrypto.Bench.Helper
  generate_benchmarks(fn(list = [_ | _]) ->
    Enum.reduce(list, quote do end, fn(%HmCrypto.Bench.Helper{
        payload:            payload,
        signature:          signature,
        digest_type:        digest_type,
        private_key:        private_key,
        key_bits_qty:       key_bits_qty,
        payload_bytes_qty:  payload_bytes_qty,
      }, acc) ->

      quote do
        unquote(acc)
        bench unquote("sign #{digest_type}/#{key_bits_qty}-bits-key/#{payload_bytes_qty}-bytes-payload") do
          HmCrypto.sign!(unquote(payload),
                         unquote(digest_type),
                         unquote(private_key |> Macro.escape))
        end
      end
    end)
  end)
end
