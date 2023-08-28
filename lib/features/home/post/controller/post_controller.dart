import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/providers/storage_repository_provider.dart';

import '../repository/post_repository.dart';

class PostController {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({required PostRepository postRepository, required Ref ref})
      : _postRepository = ref.watch(postRepositoryProvider),
        _ref = ref,
        _storageRepository = ref.read(storageRepositoryProvider);
}
