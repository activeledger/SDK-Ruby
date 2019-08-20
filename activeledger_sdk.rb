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
require '.\PreferenceUtils'
require '.\Crypto'
require '.\HTTP'
require '.\Transaction'
require '.\sseclient\SSEHandler'
require '.\sseclient\ApiUrl'


class ActiveLedgerSDK

  # prompt the user to enter the encryption type
  puts "Please enter the encryption mechanism you want ie RSA/EC"
  # encryption = gets.chop
  encryption = "RSA"

  # prompt the user to enter the key name
  puts "Please enter a Name for #{encryption} Key"
  # keyname = gets.chop
  keyname = "test"


  if(encryption == "RSA")
    type = "rsa"
  else
    type = "secp256k1"
  end

  # Creating SSEHandler class object
  sseh_instance = SSEHandler.new
  # Subscribing to URL
  sse_client = sseh_instance.sshclient("http://testnet-uk.activeledger.io:5261#{ApiUrl.getSubscribeURL()}")
  # Observing event
  sse_client.on_event { |event|
        puts "activeledger event-->: #{event.type}, #{event.data}"
    }

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

  # HTTP hit to fetch territoriality details
  response = http_instance.getTerritorialityDetails(pref_instance.territorialityDetailsURL)
  puts "response ---> #{response.body}"

end
