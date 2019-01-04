class Transaction

  # function requires (keyname , public key and type of the encryption) and creates a transaction JSON object
  def buildTxObject(keyName, publicKey, type)

    tx_obj ={
        "$contract": "onboard",
        "$namespace": "default",
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
  def buildOnboardTransaction(keyName, publicKey, type, signature)

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

    return transaction
  end


end
