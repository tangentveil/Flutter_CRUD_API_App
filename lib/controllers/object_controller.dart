import 'package:get/get.dart';
import '../models/api_object_model.dart';
import '../services/api_service.dart';

class ObjectController extends GetxController {
  final ApiService _apiService;

  ObjectController(this._apiService);

  final objects = <ApiObjectModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  final errorMessage = ''.obs;

  static const int pageSize = 20;
  int _offset = 0;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    _offset = 0;
    hasMore.value = true;
    objects.clear();
    await _fetchObjects();
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isMoreLoading.value) return;
    await _fetchObjects(isLoadMore: true);
  }

  Future<void> _fetchObjects({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final result = await _apiService.getObjects(
        limit: pageSize,
        offset: _offset,
      );

      if (result.length < pageSize) {
        hasMore.value = false;
      }
      _offset += result.length;
      objects.addAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load objects');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> createObject(ApiObjectModel obj) async {
    isLoading.value = true;
    try {
      final created = await _apiService.createObject(obj);
      objects.insert(0, created); // optimistic (after success)
      Get.back(); // close form
      Get.snackbar('Success', 'Object created');
    } catch (e) {
      Get.snackbar('Error', 'Create failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateObject(ApiObjectModel obj) async {
    isLoading.value = true;
    try {
      final updated = await _apiService.updateObject(obj);
      final index = objects.indexWhere((o) => o.id == updated.id);
      if (index != -1) {
        objects[index] = updated;
      }
      Get.back(); // close form
      Get.snackbar('Success', 'Object updated');
    } catch (e) {
      Get.snackbar('Error', 'Update failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteObject(ApiObjectModel obj) async {

    isLoading.value = true;
    final index = objects.indexWhere((o) => o.id == obj.id);
    if (index == -1) return;

    final backup = objects[index];

    objects.removeAt(index);
    Get.back();
    
    try {
      await _apiService.deleteObject(obj.id!);

      Get.snackbar('Deleted', 'Object deleted successfully');
    } catch (e) {
      // rollback
      objects.insert(index, backup);
      Get.snackbar('Error', e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
