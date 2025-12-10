import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (+91...)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => controller.phoneNumber.value = val,
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.startPhoneVerification();
                              }
                            },
                            child: const Text('Send OTP'),
                          ),
                    if (controller.errorMessage.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
