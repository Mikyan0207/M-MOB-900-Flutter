import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:starlight/domain/entities/server_entity.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';

class AuthController extends GetxController {
  Rx<UserEntity> currentUser = UserEntity().obs;
  RxList<String> currentUserServers = <String>[].obs;
  RxList<String> currentUserGroups = <String>[].obs;

  final UserRepository _userRepository = UserRepository();

  Future<void> retrieveUserFromId(String userId) async {
    currentUser(await _userRepository.get(userId));

    if (currentUser.value.servers.isNotEmpty) {
      currentUserServers(
        currentUser.value.servers.map((ServerEntity se) => se.id).toList(),
      );
    }

    if (currentUser.value.groups.isNotEmpty) {
      currentUserServers(
        currentUser.value.groups.map((GroupEntity ge) => ge.id).toList(),
      );
    }
  }

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

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserId", currentUser.value.id);

      if (currentUser.value.servers.isNotEmpty) {
        currentUserServers(
          currentUser.value.servers.map((ServerEntity se) => se.id).toList(),
        );
      }

      if (currentUser.value.groups.isNotEmpty) {
        currentUserServers(
          currentUser.value.groups.map((GroupEntity ge) => ge.id).toList(),
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
