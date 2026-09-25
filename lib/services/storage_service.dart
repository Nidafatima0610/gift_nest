/// Contract for file and asset storage (e.g. Firebase Storage, local caching).
abstract class StorageService {
  Future<String> uploadImage({
    required String path,
    required List<int> bytes,
    String? mimeType,
  });

  Future<void> deleteImage(String url);
}

/// Initial implementation stub for [StorageService].
class StorageServiceImpl implements StorageService {
  @override
  Future<String> uploadImage({
    required String path,
    required List<int> bytes,
    String? mimeType,
  }) async {
    throw UnimplementedError('Storage service will be connected to Firebase Storage');
  }

  @override
  Future<void> deleteImage(String url) async {
    // Delete logic
  }
}
