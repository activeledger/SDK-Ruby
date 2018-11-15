require 'openssl'
require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'ecdsa'
require 'securerandom'


class ActiveLedgerSDK

  puts "Please enter the encryption mechanism you want ie RSA/EC"
  encryption = gets.chop

  puts "The Encryption is #{encryption}. "


  keyname = "testkey"

  if(encryption == "RSA")
   key = OpenSSL::PKey::RSA.new(2048)
   publicKey = key.public_key

   type = "rsa"
  else
  key = OpenSSL::PKey::EC.new("secp256k1")
  key.generate_key
  pub = OpenSSL::PKey::EC.new(key.public_key.group)
  pub.public_key = key.public_key
  publicKey = pub.to_pem

  type = "secp256k1"
  end

  puts "private key = #{key.to_pem}"
  puts "public key = #{publicKey}"

   tx_obj ={
           "$contract": "onboard",
           "$namespace": "default",
           "$i": {
               "#{keyname}": {
                   "publicKey": "#{publicKey}",
                   "type": "#{type}"
               }
           }
   }

    data = tx_obj.to_json
    signature = key.sign(OpenSSL::Digest::SHA256.new, data)
    signature_base64 = Base64.encode64(signature)

    puts "signature --> #{signature_base64}"

  #generate transaction
  transaction =  {
      "$tx": {
          "$contract": "onboard",
          "$namespace": "default",
          "$i": {
              "#{keyname}": {
                  "publicKey": "#{publicKey}",
                  "type": "#{type}"
              }
          }
      },
      "$selfsign": true,
      "$sigs": {
          "#{keyname}": "#{signature_base64}"
      }
  }

  puts "transaction = #{transaction.to_json}"

  # http hit
  uri = URI.parse("http://testnet-uk.activeledger.io:5260")
  header = {'Content-Type': 'text/json'}

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = transaction.to_json

  # Send the request
  response = http.request(request)

  puts "response ---> #{response.body}"

end