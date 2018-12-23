defmodule HmCrypto.PublicKey do
  require Record

  Record.defrecord(
    :rsa_private_key,
    :RSAPrivateKey,
    Record.extract(:RSAPrivateKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  Record.defrecord(
    :dsa_private_key,
    :DSAPrivateKey,
    Record.extract(:DSAPrivateKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  Record.defrecord(
    :ec_private_key,
    :ECPrivateKey,
    Record.extract(:ECPrivateKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  @type parsed_rsa_key ::
          record(:rsa_private_key,
            version: any,
            modulus: any,
            publicExponent: any,
            privateExponent: any,
            prime1: any,
            prime2: any,
            exponent1: any,
            exponent2: any,
            coefficient: any,
            otherPrimeInfos: any
          )
          | record(:dsa_private_key,
              version: any,
              p: any,
              q: any,
              g: any,
              y: any,
              x: any
            )
          | record(
              :ec_private_key,
              version: any,
              privateKey: any,
              parameters: any,
              publicKey: any
            )

  @type rsa_key :: binary() | parsed_rsa_key()

  @moduledoc """
  API to work with RSA keys.
  """

  @doc """
  Function parses binary (string) representation of RSA key to Erlang format (tuple).
  If tuple is given as argument - returns it as is.
  """

  @spec parse_pem(rsa_key()) :: parsed_rsa_key()
  def parse_pem(pem_string) when is_binary(pem_string) and pem_string != "" do
    [pem_entry] = :public_key.pem_decode(pem_string)
    :public_key.pem_entry_decode(pem_entry)
  end

  def parse_pem(rsa_private_key() = pem), do: pem
  def parse_pem(dsa_private_key() = pem), do: pem
  def parse_pem(ec_private_key() = pem), do: pem
end
