import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

final client = Web3Client('https://alfajores-forno.celo-testnet.org', Client());

const abi = '<your-contract-abi>';
// Replace these with your actual contract ABI and remove the string quote

final contractAddress = EthereumAddress.fromHex(
    '0xfcFD51761316c7420f4f011e6509Be883C0A1412'); // replace with your actual contract address
final contractABI = json.encode(abi);

class Web3Helper {
// Create a contract instance that we can interact with
  final contract = DeployedContract(
    ContractAbi.fromJson(contractABI, "IdentityVerification"),
    contractAddress,
  );

  final credentials = EthPrivateKey.fromHex(
      "8b3f2c08e01cd6c37ad3f57a90401d280930532868e3404361c7ffd471b2a7b4"); // replace with your celo wallet private key

  Future setIdentity(String name, String dob, String nationality) async {
    final function = contract.function('setIdentity');
    final hashedName = keccak256(Uint8List.fromList(utf8.encode(name)));
    final hashedDob = keccak256(Uint8List.fromList(utf8.encode(dob)));
    final hashedNationality =
        keccak256(Uint8List.fromList(utf8.encode(nationality)));
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [hashedName, hashedDob, hashedNationality],
      ),
      chainId: 44787,
    );
    while (true) {
      final receipt = await client.getTransactionReceipt(response);
      if (receipt != null) {
        print('Transaction successful');
        print(receipt);
        break;
      }
      // Wait for a while before polling again
      await Future.delayed(const Duration(seconds: 1));
    }
    return response;
  }

  Future editIdentity({String? name, String? dob, String? nationality}) async {
    final function = contract.function('editIdentity');
    final hashedName = name != null
        ? keccak256(Uint8List.fromList(utf8.encode(name)))
        : keccak256(Uint8List.fromList(utf8.encode('')));
    final hashedDob = dob != null
        ? keccak256(Uint8List.fromList(utf8.encode(dob)))
        : keccak256(Uint8List.fromList(utf8.encode('')));
    final hashedNationality = nationality != null
        ? keccak256(Uint8List.fromList(utf8.encode(nationality)))
        : keccak256(Uint8List.fromList(utf8.encode('')));
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [hashedName, hashedDob, hashedNationality],
      ),
      chainId: 44787,
    );

    while (true) {
      final receipt = await client.getTransactionReceipt(response);
      if (receipt != null) {
        print('Transaction successful');
        print(receipt);
        break;
      }
      // Wait for a while before polling again
      await Future.delayed(const Duration(seconds: 1));
    }
    return response;
  }

  Future<bool> verifyIdentity(String claim, String value) async {
    print('start');
    print('start');
    final function = contract.function('verifyIdentity');
    final hashedValue = keccak256(Uint8List.fromList(utf8.encode(value)));
    print('start1');
    print('start1');
    final response = await client.call(
      sender: credentials.address,
      contract: contract,
      function: function,
      params: [
        EthereumAddress.fromHex(credentials.address.hex),
        claim,
        hashedValue,
      ],
    );
    print(response[0]);
    print(response[0] as bool);
    print(response);

    return response[0] as bool;
  }
}
