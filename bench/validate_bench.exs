defmodule HmCrypto.ValidateBench do
  use Benchfella
  import HmCrypto.Bench.Helper
  generate_benchmarks(fn(list = [_ | _]) ->
    Enum.reduce(list, quote do end, fn(%HmCrypto.Bench.Helper{
        payload:            payload,
        signature:          signature,
        digest_type:        digest_type,
        public_key:         public_key,
        key_bits_qty:       key_bits_qty,
        payload_bytes_qty:  payload_bytes_qty,
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
