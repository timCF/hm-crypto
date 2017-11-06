use Mix.Config

config :hm_crypto,
  digest_type: :sha256,
  private_key: fn -> File.read!("#{:code.priv_dir(:hm_crypto)}/demo_priv.pem") end,
  public_key: fn -> File.read!("#{:code.priv_dir(:hm_crypto)}/demo_pub.pem") end
