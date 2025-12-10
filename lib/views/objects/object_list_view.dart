import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
// import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class ObjectListView extends GetView<ObjectController> {
  const ObjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () => auth.logout(),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.OBJECT_FORM),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.objects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.objects.isEmpty) {
          return Center(
            child: Text('Error: ${controller.errorMessage.value}'),
          );
        }

        if (controller.objects.isEmpty) {
          return const Center(child: Text('No objects found'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                controller.hasMore.value) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: controller.objects.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.objects.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final obj = controller.objects[index];
              final dataPreview = (obj.data ?? {}).keys
                  .take(2)
                  .map((k) => '$k: ${obj.data![k]}')
                  .join(', ');

              return ListTile(
                title: Text(obj.name),
                subtitle: Text('ID: ${obj.id}\n$dataPreview'),
                isThreeLine: true,
                onTap: () => Get.toNamed(
                  Routes.OBJECT_DETAIL,
                  arguments: obj,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
