defmodule HmCrypto do
  @rsa_digest_types ~w(md5 ripemd160 sha sha224 sha256 sha384 sha512)a

  @digest_type (
    digest_type = Application.get_env(:hm_crypto, :digest_type)
    true = Enum.member?(@rsa_digest_types, digest_type)
    digest_type
  )

  @private_key Application.get_env(:hm_crypto, :private_key).()
  @public_key  Application.get_env(:hm_crypto, :public_key).()

  def sign(message, digest_type \\ @digest_type, private_key \\ @private_key)
      when is_binary(message) do
    :public_key.sign(message, digest_type, parse_pem(private_key))
    |> Base.encode64
  end

  def valid?(message, encoded_signature, digest_type \\ @digest_type, public_key \\ @public_key)
      when is_binary(message) do
    {:ok, signature} = Base.decode64(encoded_signature)
    :public_key.verify(message, digest_type, signature, parse_pem(public_key))
  end

  defp parse_pem(pem_string) do
    [pem_entry] = :public_key.pem_decode(pem_string)
    :public_key.pem_entry_decode(pem_entry)
  end
end
