=begin
  MIT License (MIT)
  Copyright (c) 2018
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
=end

require 'openssl'
require 'base64'

class Crypto

  @@publicKey = ""
  @@privateKey = ""
  @@keyObj = ""

  # function takes encryption type and generate public and private key
  def Crypto.generateKeys(encryption)

    puts "generting #{encryption} key"

    if(encryption == "rsa")

      key = OpenSSL::PKey::RSA.new(2048)
      @@keyObj = key
      @@publicKey = key.public_key
      @@privateKey = key.to_pem
    else

      key = OpenSSL::PKey::EC.new("secp256k1")
      key.generate_key
      @@keyObj = key
      # extracting public key from keypair object
      pub = OpenSSL::PKey::EC.new(key.public_key.group)
      pub.public_key = key.public_key
      
      # converting public and private key to PEM format
      @@publicKey = pub.to_pem
      @@privateKey = key.to_pem
    end

  end

  # function takes a transaction and returns the signature
  def Crypto.signTransaction(transaction)

    signature = getKeyObject.sign(OpenSSL::Digest::SHA256.new, transaction)

    return signature
  end

  def Crypto.base64Encoding(data)
    return Base64.encode64(data)
  end

  def Crypto.getPublicKey
    return @@publicKey
  end

  def Crypto.getPrivateKey
    return @@privateKey
  end

  def Crypto.getKeyObject
    return @@keyObj
  end


end

