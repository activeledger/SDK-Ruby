<img src="https://www.activeledger.io/wp-content/uploads/2018/09/Asset-23.png" alt="Activeledger" width="500"/>

# Activeledger - Ruby SDK

The Activeledger Ruby SDK has been built to provide an easy way to connect your Ruby Project to an Activeledger Network

### Activeledger

[Visit Activeledger.io](https://activeledger.io/)

[Read Activeledgers documentation](https://github.com/activeledger/activeledger)


## Usage

The SDK currently supports the following functionality

- Connection handling
- Key generation and Handling
- Key onboarding
- Transaction building

### Connection

When sending a transaction, you must pass a connection that provides the information needed to establish a link to the network and specified node.

To do this a connection object must be created. This object must be passed the protocol, address, and port.

```Ruby
PreferenceUtils.setConnection("protocol","url","port")
```
#### Example
```Ruby
PreferenceUtils.setConnection("http","testnet-uk.activeledger.io","5260")
```

---

### Key

There are two key types that can be generated currently, more are planned and will be implemented into Activeledger first. These types are RSA and Elliptic Curve.

#### Generating a key


##### Example

```Ruby
KeyType = "EC" or "RSA"

Crypto.generateKeys(type)
```

#### Exporting Key


##### Example

```Ruby
PreferenceUtils.writeKeyInFile("PublicKey.txt",crypto_instance.getPublicKey)
PreferenceUtils.writeKeyInFile("PrivateKey.txt",crypto_instance.getPrivateKey)
```


#### Creating and Sending Onboard Transaction

Once you have a key generated, to use it to sign transactions it must be onboarded to the ledger network. For that purposes you need to create an Onboard Transaction

##### Example

```Ruby
tx_obj =Transaction.buildTxObject("onboard", "default", keyname,Crypto.getPublicKey,type)
transaction = PreferenceUtils.convertJSONToString(tx_obj)
signature = Crypto.signTransaction(transaction)
signature_base64 = Crypto.base64Encoding(signature)
response = Transaction.generateAndSendOnboardTransaction(keyname, Crypto.getPublicKey, type ,signature_base64)
```

Onboard Transaction internally extracts the onboard_id and can be access through

```Ruby
PreferenceUtils.getOnboardID
```
---


#### Creating Labeled Transaction

Once you have onboarded the keys to the ledger the user can create labeled transactions that uses the streams id to verify transaction. The method will complete the transaction and add a signature for the user.

##### Example

```Ruby
transaction =Transaction.createLabeledTransaction(tx_object)
```
---


#### Signing & sending a transaction

When signing a transaction you must send the finished version of it. No changes can be made after signing as this will cause the ledger to reject it.
Once the transaction has been created the user has two choices. Either the transaction is signed manually or the SDK will add the signature.

The key must be one that has been successfully onboarded to the ledger which the transaction is being sent to.

##### Example

```Ruby
tx_obj =Transaction.buildTxObject(keyname,crypto_instance.getPublicKey,type)

#Manual Signing
transaction = PreferenceUtils.convertJSONToString(tx_obj)
signature = Crypto.signTransaction(transaction)
signature_base64 = Crypto.base64Encoding(signature)

transaction = Transaction.buildOnboardTransaction(keyname, Crypto.getPublicKey, type ,signature_base64)

#SDK Signing
transaction = Transaction.createAndSignTransaction(tx_obj)

#Http Hit
http_instance = HTTP.new
response = HTTP.doHttpHit(PreferenceUtils.getConnection,PreferenceUtils.convertJSONToString(transaction))
```
---


#### Server Sent Event

Server Sent Events can be subscribed by setting the event URL in PreferenceUtils. If the application want to subscribe to multiple events having different base URL then URL can be passed as a string in sshclient parameter. The available API endpoints can be found in ApiUrl.

##### Example

```Ruby
# Creating SSEHandler class object
sseh_instance = SSEHandler.new
# Subscribing to URL
sse_client = sseh_instance.sshclient("#{ApiUrl.getSubscribeURL()}")
# Observing event
sse_client.on_event { |event|
      puts "activeledger event-->: #{event.type}, #{event.data}"
}
```
## License

---

This project is licensed under the [MIT](https://github.com/activeledger/SDK-Ruby/blob/master/LICENSE) License


