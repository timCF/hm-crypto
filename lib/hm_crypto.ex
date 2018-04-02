defmodule HmCrypto do
  import HmCrypto.PublicKey

  @rsa_digest_types ~w(md5 ripemd160 sha sha224 sha256 sha384 sha512)a

  def rsa_digest_types, do: @rsa_digest_types

  def sign!(message, digest_type, private_key) when
        is_binary(message) and
        (digest_type in @rsa_digest_types) do

    message
    |> :public_key.sign(digest_type, parse_pem(private_key))
    |> Base.encode64
  end

  def valid?(message, encoded_signature, digest_type, public_key) when
        is_binary(message) and
        is_binary(encoded_signature) and
        (digest_type in @rsa_digest_types) do

    encoded_signature
    |> Base.decode64(ignore: :whitespace)
    |> case do
      {:ok, signature} ->
        :public_key.verify(message, digest_type, signature, parse_pem(public_key))
      _ ->
        false
    end
  end

end
