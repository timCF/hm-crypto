defmodule HmCrypto.PublicKey do
  def parse_pem(pem_string) when is_binary(pem_string) and (pem_string != "") do
    [pem_entry] = :public_key.pem_decode(pem_string)
    :public_key.pem_entry_decode(pem_entry)
  end
  def parse_pem(pem) when is_tuple(pem), do: pem
end
