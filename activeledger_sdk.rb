require 'openssl'
require 'json'
require 'net/http'
require 'uri'
require 'base64'
require '.\PreferenceUtils'
require '.\Crypto'
require '.\HTTP'
require '.\Transaction'


class ActiveLedgerSDK


  puts "Please enter the encryption mechanism you want ie RSA/EC"
  encryption = gets.chop

  puts "Please enter a Name for #{encryption} Key"
  keyname = gets.chop


  if(encryption == "RSA")
    type = "rsa"
  else
    type = "secp256k1"
  end

  pref_instance = PreferenceUtils.new
  pref_instance.setConnection("http","testnet-uk.activeledger.io","5260")
  puts "get connection #{pref_instance.getConnection}"

  crypto_instance = Crypto.new
  crypto_instance.generateKeys(encryption)

  puts "private key = #{crypto_instance.getPrivateKey}"
  puts "public key = #{crypto_instance.getPublicKey}"

  pref_instance.writeKeyInFile("PublicKey.txt",crypto_instance.getPublicKey)
  pref_instance.writeKeyInFile("PrivateKey.txt",crypto_instance.getPrivateKey)


  transaction_instance = Transaction.new
  tx_obj =transaction_instance.buildTxObject(keyname,crypto_instance.getPublicKey,type)

  transaction = pref_instance.convertJSONToString(tx_obj)
  signature = crypto_instance.signTransaction(transaction)
  signature_base64 = crypto_instance.base64Encoding(signature)

  puts "signature --> #{signature_base64}"



  transaction = transaction_instance.buildOnboardTransaction(keyname, crypto_instance.getPublicKey, type ,signature_base64)

  puts "transaction = #{transaction.to_json}"


  ###done

  http_instance = HTTP.new
  response = http_instance.doHttpHit(pref_instance.getConnection,transaction.to_json)

  puts "response ---> #{response.body}"



end