import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/api_object_model.dart';
import '../../controllers/object_controller.dart';
import '../../utils/validators.dart';

class ObjectFormView extends GetView<ObjectController> {
  const ObjectFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiObjectModel? existing = Get.arguments;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: existing?.name ?? '');
    final dataController = TextEditingController(
      text: existing?.data != null
          ? const JsonEncoder.withIndent('  ').convert(existing!.data)
          : '{}',
    );

    final isEdit = existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Object' : 'Create Object')),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dataController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Data (JSON)',
                      border: OutlineInputBorder(),
                    ),
                    validator: validateJson,
                  ),
                  const SizedBox(height: 16),
                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final Map<String, dynamic> data =
                                jsonDecode(dataController.text);

                            final obj = ApiObjectModel(
                              id: existing?.id,
                              name: nameController.text.trim(),
                              data: data,
                            );

                            if (isEdit) {
                              controller.updateObject(obj);
                            } else {
                              controller.createObject(obj);
                            }
                          },
                          child: Text(isEdit ? 'Update' : 'Create'),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
