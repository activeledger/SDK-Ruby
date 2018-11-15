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
pref_instance = PreferenceUtils.new
pref_instance.setConnection("protocol","url","port")
```
#### Example
```Ruby
pref_instance = PreferenceUtils.new
pref_instance.setConnection("http","testnet-uk.activeledger.io","5260")
```

---

### Key

There are two key types that can be generated currently, more are planned and will be implemented into Activeledger first. These types are RSA and Elliptic Curve.

#### Generating a key


##### Example

```Ruby
KeyType = "EC" or "RSA"

crypto_instance = Crypto.new
crypto_instance.generateKeys(type)
```

#### Exporting Key


##### Example

```Ruby
pref_instance.writeKeyInFile("PublicKey.txt",crypto_instance.getPublicKey)
pref_instance.writeKeyInFile("PrivateKey.txt",crypto_instance.getPrivateKey)
```


#### Creating Onboard Transaction

Once you have a key generated, to use it to sign transactions it must be onboarded to the ledger network. For that purposes you need to create an Onboard Transaction

##### Example

```Ruby
transaction = transaction_instance.buildOnboardTransaction(keyname, crypto_instance.getPublicKey, type ,signature_base64)
```

---

### Transaction

Creating a transaction

```Ruby
//to build
```


#### Signing & sending a transaction

When signing a transaction you must send the finished version of it. No changes can be made after signing as this will cause the ledger to reject it.

The key must be one that has been successfully onboarded to the ledger which the transaction is being sent to.

##### Example

```Ruby
transaction_instance = Transaction.new
tx_obj =transaction_instance.buildTxObject(keyname,crypto_instance.getPublicKey,type)

transaction = pref_instance.convertJSONToString(tx_obj)
signature = crypto_instance.signTransaction(transaction)
signature_base64 = crypto_instance.base64Encoding(signature)

transaction = transaction_instance.buildOnboardTransaction(keyname, crypto_instance.getPublicKey, type ,signature_base64)

http_instance = HTTP.new
response = http_instance.doHttpHit(pref_instance.getConnection,transaction.to_json)
```

## License

---

This project is licensed under the [MIT](https://github.com/activeledger/activeledger/blob/master/LICENSE) License


