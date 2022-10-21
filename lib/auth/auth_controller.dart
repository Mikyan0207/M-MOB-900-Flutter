
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';

class AuthController extends GetxController {

  UserEntity? currentUser;

  final UserRepository _userRepository = UserRepository();

  Future<bool> loginAsync(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return false;
      }

      print(userCredential.user!.uid);

      currentUser = await _userRepository.get(userCredential.user!.uid);

      print(currentUser);

      return true;

    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  Future<bool> registerAsync(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return false;
      }

      print(userCredential.user);

      currentUser = await _userRepository.create(
        UserEntity(
          id: userCredential.user!.providerData[0].uid!,
          email: userCredential.user!.email,
        ),
      );

      print(currentUser);

      return true;

    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}