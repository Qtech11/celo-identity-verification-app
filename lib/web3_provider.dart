import 'package:celo_identity_verification/web3_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Status { init, loading, done }

final web3Provider = ChangeNotifierProvider((ref) => Web3Provider());

class Web3Provider extends ChangeNotifier {
  Status setIdentityStatus = Status.init;
  Status verifyNameStatus = Status.init;
  Status verifyDOBStatus = Status.init;
  Status verifyCountryStatus = Status.init;

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> setIdentity(
      {required String name,
      required String date,
      required String country,
      required context}) async {
    setIdentityStatus = Status.loading;
    notifyListeners();
    final response = await Web3Helper().setIdentity(name, date, country);
    if (response != null) {
      _showSnackBar(context, 'Identity set was successful');
    } else {
      _showSnackBar(context, 'An error occurred while setting status');
    }
    setIdentityStatus = Status.done;
    notifyListeners();
  }

  Future<void> verifyName(String value, BuildContext context) async {
    verifyNameStatus = Status.loading;
    notifyListeners();
    await Web3Helper().verifyIdentity('name', value).then((value) {
      if (value) {
        _showSnackBar(context, 'Verification successful');
      } else {
        _showSnackBar(context, 'Invalid Name');
      }
    });

    verifyNameStatus = Status.done;
    notifyListeners();
  }

  Future<void> verifyDateOfBirth(String value, BuildContext context) async {
    verifyDOBStatus = Status.loading;
    notifyListeners();
    await Web3Helper().verifyIdentity('dob', value).then((value) {
      if (value) {
        _showSnackBar(context, 'Verification successful');
      } else {
        _showSnackBar(context, 'Invalid Date of Birth');
      }
    });

    verifyDOBStatus = Status.done;
    notifyListeners();
  }

  Future<void> verifyCountry(String value, BuildContext context) async {
    verifyCountryStatus = Status.loading;
    notifyListeners();
    await Web3Helper().verifyIdentity('nationality', value).then((value) {
      if (value) {
        _showSnackBar(context, 'Verification successful');
      } else {
        _showSnackBar(context, 'Invalid Country');
      }
    });

    verifyCountryStatus = Status.done;
    notifyListeners();
  }
}
