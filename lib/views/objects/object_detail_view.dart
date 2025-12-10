import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/api_object_model.dart';
import '../../controllers/object_controller.dart';
import '../../routes/app_routes.dart';

class ObjectDetailView extends GetView<ObjectController> {
  const ObjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ObjectController controller = Get.find<ObjectController>();
    final ApiObjectModel obj = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(obj.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(Routes.OBJECT_FORM, arguments: obj),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Confirm delete'),
                  content: const Text(
                    'Are you sure you want to delete this item?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => 
                        Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              // print(shouldDelete);
              if (shouldDelete == true) {
                controller.deleteObject(obj);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('ID: ${obj.id}'),
            const SizedBox(height: 8),
            const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              (obj.data ?? {}).entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join('\n'),
            ),
          ],
        ),
      ),
    );
  }
}
