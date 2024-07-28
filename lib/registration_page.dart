import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});

class RegistrationState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  RegistrationState(
      {this.isLoading = false, this.error, this.isSuccess = false});
}

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String birthdate,
    required String phone,
    required String email,
    required String password,
    required String maritalStatus,
    required String educationalStatus,
    required String employmentStatus,
  }) async {
    state = RegistrationState(isLoading: true);

    try {
      final response = await Supabase.instance.client.from('users').insert({
        'first_name': firstName,
        'last_name': lastName,
        'birthdate': birthdate,
        'phone': phone,
        'email': email,
        'password': password,
        'marital_status': maritalStatus,
        'educational_status': educationalStatus,
        'employment_status': employmentStatus,
      }).select();

      if (response.isEmpty) {
        state = RegistrationState(error: 'Failed to register user');
      } else {
        state = RegistrationState(isSuccess: true);
      }
    } catch (e) {
      state = RegistrationState(error: e.toString());
    }
  }
}

class RegistrationPage extends ConsumerWidget {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String maritalStatus = 'Single';
  String educationalStatus = 'Not Studying';
  String employmentStatus = 'Unemployed';

  RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationProvider);

    if (registrationState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registrationState.error!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }

    if (registrationState.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    birthdateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: birthdateController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  } else if (int.tryParse(value) == null) {
                    return 'Phone number must be an integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  } else if (!value.endsWith('@gmail.com')) {
                    return 'Email must end with @gmail.com';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: maritalStatus,
                decoration: const InputDecoration(labelText: 'Marital Status'),
                items: ['Single', 'Married'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  maritalStatus = newValue!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: educationalStatus,
                decoration:
                    const InputDecoration(labelText: 'Educational Status'),
                items: ['Studying', 'Not Studying'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  educationalStatus = newValue!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: employmentStatus,
                decoration:
                    const InputDecoration(labelText: 'Employment Status'),
                items: ['Employed', 'Unemployed'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  employmentStatus = newValue!;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 30,
                width: 150,
                child: FloatingActionButton(
                  onPressed: registrationState.isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(registrationProvider.notifier)
                                .registerUser(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  birthdate: birthdateController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  maritalStatus: maritalStatus,
                                  educationalStatus: educationalStatus,
                                  employmentStatus: employmentStatus,
                                );
                          }
                        },
                  child: registrationState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
