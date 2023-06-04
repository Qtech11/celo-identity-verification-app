import 'package:celo_identity_verification/web3_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'custom_text_field.dart';

class SetIdentityScreen extends ConsumerStatefulWidget {
  const SetIdentityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SetIdentityScreen> createState() => _SetIdentityScreenState();
}

class _SetIdentityScreenState extends ConsumerState<SetIdentityScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  Future<dynamic> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1930),
      firstDate: DateTime(1930),
      lastDate: DateTime(2005),
    );
    if (pickedDate != null) {
      return pickedDate;
    } else {
      return 'n';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(web3Provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Identity'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: nameController,
                hintText: 'Enter name',
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: dobController,
                readOnly: true,
                hintText: 'Select date',
                iconButton: IconButton(
                  onPressed: () async {
                    dynamic date = await pickDate();
                    if (date == 'n') return;
                    String pickedDate = DateFormat('dd-MM-yyyy').format(date);
                    // String pickedDate = DateFormat('yyyy-MM-dd').format(date);
                    setState(() {
                      dobController.text = pickedDate;
                    });
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hintText: 'Enter country',
                controller: countryController,
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.teal),
                  child: state.setIdentityStatus == Status.loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Set Identity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        dobController.text.trim().isEmpty ||
                        countryController.text.trim().isEmpty) {
                      return;
                    }
                    state.setIdentity(
                      name: nameController.text.trim(),
                      date: dobController.text.trim(),
                      country: countryController.text.trim(),
                      context: context,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
