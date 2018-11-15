require 'openssl'
require 'base64'

class Crypto

  $publicKey = ""
  $privateKey = ""
  $keyObj = ""

  def generateKeys(encryption)

    if(encryption == "RSA")
      key = OpenSSL::PKey::RSA.new(2048)
      $keyObj = key
      $publicKey = key.public_key
      $privateKey = key.to_pem
    else
      key = OpenSSL::PKey::EC.new("secp256k1")
      key.generate_key
      $keyObj = key
      pub = OpenSSL::PKey::EC.new(key.public_key.group)
      pub.public_key = key.public_key
      $publicKey = pub.to_pem
      $privateKey = key.to_pem
    end

  end

  def signTransaction(transaction)

    signature = getKeyObject.sign(OpenSSL::Digest::SHA256.new, transaction)

    return signature
  end

  def base64Encoding(data)
    return Base64.encode64(data)
  end

  def getPublicKey
    return $publicKey
  end

  def getPrivateKey
    return $privateKey
  end

  def getKeyObject
    return $keyObj
  end


end

