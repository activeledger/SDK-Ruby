class Transaction

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