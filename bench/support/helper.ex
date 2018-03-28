defmodule HmCrypto.Bench.Helper do

  defstruct [
    :payloads,
    :private_keys,
    :public_keys,
  ]

  defmacro generate_benchmarks(quoted_lambda) do

    {lambda, []} =
      Code.eval_quoted(quoted_lambda)

    payloads =
      [1, 100, 100000]
      |> Enum.reduce(%{}, fn(bytes, acc) ->
        Map.put(acc, bytes, :crypto.strong_rand_bytes(bytes))
      end)

    private_keys =
      fetch_keys("")

    public_keys =
      fetch_keys(".pub")

    lambda.(%__MODULE__{
      payloads: payloads,
      private_keys: private_keys,
      public_keys: public_keys,
    })
  end

  defp fetch_keys(postfix) do
    [1024, 2048]
    |> Enum.reduce(%{}, fn(bits, acc) ->
      key =
        "#{:code.priv_dir :hm_crypto}/#{bits}#{postfix}"
        |> File.read!
        |> HmCrypto.PublicKey.parse_pem
        |> Macro.escape
      Map.put(acc, bits, key)
    end)
  end

end
