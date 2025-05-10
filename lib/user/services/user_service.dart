import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UserService {
  void sayHello();
  Future<String?> uploadUserProfilePhoto();
}

class UserController implements UserService {
  @override
  Future<String?> uploadUserProfilePhoto() async {
    throw UnimplementedError();
  }

  @override
  void sayHello() {
    print('say hello form real user');
  }
}

class UserTestController implements UserService {
  @override
  Future<String?> uploadUserProfilePhoto() {
    throw UnimplementedError();
  }

  @override
  void sayHello() {
    print("Hello from test");
  }
}

final userControllerProvider = Provider<UserService>((ref) => UserController());

final userProvider = StateNotifierProvider<UserStateNotifer, User>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  final userService = ref.watch(userControllerProvider);
  return UserStateNotifer(user!, userService);
});

class UserStateNotifer extends StateNotifier<User> {
  final UserService userService;
  UserStateNotifer(super.state, this.userService) {
    sayHello();
  }

  void sayHello() {
    print("user: ${state.displayName}");
    userService.sayHello();
  }
}
