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
  encryption = gets.chop

  # prompt the user to enter the key name
  puts "Please enter a Name for #{encryption} Key"
  keyname = gets.chop

  if(encryption == "RSA")
    type = "rsa"
  else
    type = "secp256k1"
  end

  # Setting up the connection
  PreferenceUtils.setConnection("http","testnet-uk.activeledger.io","5260")
  puts "get connection #{PreferenceUtils.getConnection}"

  # generting keys of required encryption
  Crypto.generateKeys(type)

  puts "private key = #{Crypto.getPrivateKey}"
  puts "public key = #{Crypto.getPublicKey}"
  
  # Writing public and private key to a file
  PreferenceUtils.writeKeyInFile("PublicKey.txt",Crypto.getPublicKey)
  PreferenceUtils.writeKeyInFile("PrivateKey.txt",Crypto.getPrivateKey)

  # Creating Transaction JSON object
  tx_obj =Transaction.buildTxObject("onboard", "default", keyname,Crypto.getPublicKey,type)

  # Converting JSON object to string
  transaction = PreferenceUtils.convertJSONToString(tx_obj)
  puts "tx obj --> #{transaction}"

  # signing the transaction
  signature = Crypto.signTransaction(transaction)
  # encoding the signature to base64
  signature_base64 = Crypto.base64Encoding(signature)
  puts "signature --> #{signature_base64}"
  
  # Creting onboard transaction, sending to ledger and extracting the onboard_id
  response = Transaction.generateAndSendOnboardTransaction(keyname, Crypto.getPublicKey, type ,signature_base64)
  puts "response ---> #{response.body}"
  puts "stream id --> #{PreferenceUtils.getOnboardID}"
  
  # HTTP hit to fetch territoriality details
  response = HTTP.getTerritorialityDetails(PreferenceUtils.territorialityDetailsURL)
  puts "response ---> #{response.body}"

  # Creating SSEHandler class object
  sseh_instance = SSEHandler.new
  # Subscribing to URL
  sse_client = sseh_instance.sshclient("#{ApiUrl.getSubscribeURL()}")
  # Observing event
  sse_client.on_event { |event|
        puts "activeledger event-->: #{event.type}, #{event.data}"
  }

end
