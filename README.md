<img src="https://www.activeledger.io/wp-content/uploads/2018/09/Asset-23.png" alt="Activeledger" width="500"/>

# Activeledger - Xamarin SDK

The Activeledger Xamarin SDK has been built to provide an easy way to connect your Xamarin application to an Activeledger Network

### Activeledger

[Visit Activeledger.io](https://activeledger.io/)

[Read Activeledgers documentation](https://github.com/activeledger/activeledger)


## Usage

The SDK currently supports the following functionality

- Connection handling
- Key generation
- Key onboarding
- Transaction building

### Connection

When sending a transaction, you must pass a connection that provides the information needed to establish a link to the network and specified node.

To do this a connection object must be created. This object must be passed the protocol, address, and port.

```c#
ActiveLedgerLib.SDKPreferences.setConnection("protocol", "url", "port");
```
#### Example
```c#
ActiveLedgerLib.SDKPreferences.setConnection("http", "testnet-uk.activeledger.io", "5260");
```

---

### Key

There are two key types that can be generated currently, more are planned and will be implemented into Activeledger first. These types are RSA and Elliptic Curve.

#### Generating a key


##### Example

```c#
String KeyType = "EC" or "RSA";

AsymmetricCipherKeyPair keypair = ActiveLedgerLib.GenerateKeyPair.GetKeyPair(KeyType);
```

#### Exporting Key


##### Example

```c#
 ActiveLedgerLib.Helper.SaveKeyToFile(ActiveLedgerLib.Helper.GetPrivateKey(keypair), "privatekey.pem");
 ActiveLedgerLib.Helper.SaveKeyToFile(ActiveLedgerLib.Helper.GetPublicKey(keypair), "publickey.pem");
```


#### Onboarding a key

Once you have a key generated, to use it to sign transactions it must be onboarded to the ledger network

##### Example

```c#
JObject json = ActiveLedgerLib.GenerateTxJson.GetTxJsonForOnboardingKeys(keypair, KeyType);

string json_str = ActiveLedgerLib.Helper.ConvertJsonToString(json);

var response = ActiveLedgerLib.MakeRequest.makeRequestAsync(ActiveLedgerLib.SDKPreferences.url, json_str);
```

---

### Transaction

Creating a transaction

```c#
JObject jObject = ActiveLedgerLib.GenerateTxJson.GetBasicTxJson(JObject tx, Nullable < bool > selfSign, string sigs);
```


#### Signing & sending a transaction

When signing a transaction you must send the finished version of it. No changes can be made after signing as this will cause the ledger to reject it.

The key must be one that has been successfully onboarded to the ledger which the transaction is being sent to.

##### Example

```c#
JObject tx = <transaction to send>
string tx_str = Helper.ConvertJsonToString(tx);
           
//converting transaction in to byte Array
byte[] originalData = Helper.ConvertStringToByteArray(tx_str);
//signing the transaction
if (keyType == "RSA")
{
   RsaKeyParameters priKey = (RsaKeyParameters)keypair.Private;
   byte[] signedData = GenerateSignature.GetSignatureRSA(originalData, priKey);
}
else
{
   ECKeyParameters priECKey = (ECKeyParameters)keypair.Private;
   byte[] signedData = GenerateSignature.GetSignatureEC(originalData, priECKey);
}


//sending the transaction to ActiveLedger
var response = ActiveLedgerLib.MakeRequest.makeRequestAsync(ActiveLedgerLib.SDKPreferences.url, json_str);
```

## License

---

This project is licensed under the [MIT](https://github.com/activeledger/activeledger/blob/master/LICENSE) License


