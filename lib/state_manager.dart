import 'package:flutter_multiplatformtest_app/grid_photo.dart';
import 'package:flutter_multiplatformtest_app/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_request.dart';

int countPage = 1;

GridPhoto userData = GridPhoto();

final countGridProvider = StateProvider((ref) => userData.length);

final userStateFuture = FutureProvider<List<User>>((ref) async {
  return fetchUsers(countPage);
});
