import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';

class AuthController extends GetxController {
  Rx<UserEntity> currentUser = UserEntity().obs;
  RxList<String> currentUserServers = <String>[].obs;

  final UserRepository _userRepository = UserRepository();

  Future<bool> loginAsync(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return false;
      }

      currentUser(await _userRepository.get(userCredential.user!.uid));
      if (currentUser.value.id == '') {
        await Fluttertoast.showToast(msg: "Current User is null");
        await Get.to(() => SignInScreen());
      }

      if (currentUser.value.servers.isNotEmpty) {
        currentUserServers(
          currentUser.value.servers.map((ServerEntity se) => se.id).toList(),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await Fluttertoast.showToast(msg: 'User not found');
      } else {
        await Fluttertoast.showToast(msg: e.toString());
      }
      return false;
    }
  }

  Future<bool> registerAsync(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return false;
      }

      currentUser(
        await _userRepository.create(
          UserEntity(
            id: userCredential.user!.uid,
            username: userCredential.user!.email!.split('@').first,
            email: userCredential.user!.email!,
          ),
        ),
      );

      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
