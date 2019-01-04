

require '.\PreferenceUtils'
require '.\Crypto'
require '.\HTTP'
require '.\Transaction'


class ActiveLedgerSDK

  # prompt the user to enter the encryption type
  puts "Please enter the encryption mechanism you want ie RSA/EC"
  encryption = gets.chop

  # prompt the user to enter the key name
  puts "Please enter a Name for #{encryption} Key"
  keyname = gets.chop


  if(encryption == "RSA")
    type = "rsa"
  else
    type = "secp256k1"
  end

  # Creating preferenceUtils class object
  pref_instance = PreferenceUtils.new
  # Setting up the connection
  pref_instance.setConnection("http","testnet-uk.activeledger.io","5260")
  puts "get connection #{pref_instance.getConnection}"

  # Creating Crypto class object
  crypto_instance = Crypto.new  
  
  # generting keys of required encryption
  crypto_instance.generateKeys(type)

  puts "private key = #{crypto_instance.getPrivateKey}"
  puts "public key = #{crypto_instance.getPublicKey}"
  
  # Writing public and private key to a file
  pref_instance.writeKeyInFile("PublicKey.txt",crypto_instance.getPublicKey)
  pref_instance.writeKeyInFile("PrivateKey.txt",crypto_instance.getPrivateKey)

  # Creating Transaction class object
  transaction_instance = Transaction.new
  # Creating Transaction JSON object
  tx_obj =transaction_instance.buildTxObject(keyname,crypto_instance.getPublicKey,type)

  # Converting JSON object to string
  transaction = pref_instance.convertJSONToString(tx_obj)
  # signing the transaction
  signature = crypto_instance.signTransaction(transaction)
  # encoding the signature to base64
  signature_base64 = crypto_instance.base64Encoding(signature)

  puts "signature --> #{signature_base64}"
  
  # Creting onboard transaction 
  transaction = transaction_instance.buildOnboardTransaction(keyname, crypto_instance.getPublicKey, type ,signature_base64)

  puts "transaction = #{pref_instance.convertJSONToString(transaction)}"

  # Creating HTTP class object
  http_instance = HTTP.new
  
  # HTTP hit
  response = http_instance.doHttpHit(pref_instance.getConnection,pref_instance.convertJSONToString(transaction))

  puts "response ---> #{response.body}"



end
