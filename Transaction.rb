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
require '.\Crypto'
require '.\PreferenceUtils'

class Transaction

  # function requires (keyname , public key and type of the encryption) and creates a transaction JSON object
  def Transaction.buildTxObject(contract, namespace, keyName, publicKey, type)

    tx_obj ={
        "$contract": "#{contract}",
        "$namespace": "#{namespace}",
        "$i": {
            "#{keyName}": {
                "publicKey": "#{publicKey}",
                "type": "#{type}"
            }
        }
    }

    return tx_obj
  end


  # function requires (keyname , public key, signature of transaction object and type of the encryption) and creates an onboard
  #  transaction JSON object
  def Transaction.generateAndSendOnboardTransaction(keyName, publicKey, type, signature)

    #generate transaction
    transaction =  {
        "$tx": {
            "$contract": "onboard",
            "$namespace": "default",
            "$i": {
                "#{keyName}": {
                    "publicKey": "#{publicKey}",
                    "type": "#{type}"
                }
            }
        },
        "$selfsign": true,
        "$sigs": {
            "#{keyName}": "#{signature}"
        }
    }

    response = HTTP.doHttpHit(PreferenceUtils.getConnection,PreferenceUtils.convertJSONToString(transaction))
    PreferenceUtils.extractStreamID(response.body)

    return response
  end


  def Transaction.buildBaseTransaction(territorialityReference, transactionObject, selfsign, sigsObject)

    #generate transaction
    transaction =  {
        "$territoriality": "#{territorialityReference}",
        "$tx": "#{transactionObject}" ,
        "$selfsign": "#{selfsign}" ,
        "$sigs": "#{sigsObject}"
    }

    return transaction
  end


  def Transaction.createAndSignTransaction(transactionObject)

  signature = Crypto.signTransaction(PreferenceUtils.convertJSONToString(transactionObject))
  signature_base64 = Crypto.base64Encoding(signature)

    sigsObject =  {
      "#{PreferenceUtils.getOnboardID}": "#{signature_base64}"
    }

    transaction =  {
        "$tx": transactionObject ,
        "$selfsign": false ,
        "$sigs": sigsObject
    }

    return transaction
  end


  def Transaction.createLabeledTransaction(transactionObject)
  
    transactionObject_new = PreferenceUtils.convertJSONToString(transactionObject)
    transactionObject_new = JSON.parse(transactionObject_new)
    stream_id = transactionObject_new["$i"]["#{(transactionObject_new["$i"].keys)[0]}"]["$stream"]

    signature = Crypto.signTransaction(PreferenceUtils.convertJSONToString(transactionObject))
    signature_base64 = Crypto.base64Encoding(signature)
  
      sigsObject =  {
        "#{stream_id}": "#{signature_base64}"
      }
  
      transaction =  {
          "$tx": transactionObject ,
          "$selfsign": false ,
          "$sigs": sigsObject
      }
  
      return transaction
  end

end
