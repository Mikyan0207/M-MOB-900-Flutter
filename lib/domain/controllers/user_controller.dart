import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/domain/repositories/user_repository.dart';
import 'package:starlight/presentation/sign_in/sign_in_screen.dart';

class UserController extends GetxController {
  Rx<UserEntity> currentUser = UserEntity().obs;

  final UserRepository repository = UserRepository();

  Future<void> setCurrentUser(String userId) async {
    currentUser(
      await repository.get(
        userId.isEmpty ? currentUser.value.id : userId,
        options: const UserQueryOptions(
          includeServers: true,
          includeGroups: true,
          includeFriends: true,
        ),
      ),
    );

    await repository.updateField(
      currentUser.value,
      <String, dynamic>{
        'Status': "online",
      },
      merge: true,
    );
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

      currentUser(
        await repository.getByAuthId(
          userCredential.user!.uid,
          options: const UserQueryOptions(
            includeServers: true,
            includeGroups: true,
            includeFriends: true,
          ),
        ),
      );
      if (currentUser.value.id == '') {
        await Fluttertoast.showToast(msg: "Error during Sign in.");
        await Get.to(() => SignInScreen());
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserId", currentUser.value.id);

      await repository.updateField(
        currentUser.value,
        <String, dynamic>{
          'Status': "online",
        },
        merge: true,
      );

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

      final int discriminatorGenerator = Random().nextInt(9999);
      await repository.create(
        UserEntity(
          authId: userCredential.user!.uid,
          username: userCredential.user!.email!.split('@').first,
          email: userCredential.user!.email!,
          discriminator: '#${discriminatorGenerator.toString().padLeft(4, '0')}',
          avatar: "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
        ),
      );

      currentUser(
        await repository.getByAuthId(
          userCredential.user!.uid,
          options: const UserQueryOptions(
            includeServers: true,
            includeGroups: true,
            includeFriends: true,
          ),
        ),
      );

      await repository.updateField(
        currentUser.value,
        <String, dynamic>{
          'Status': "online",
        },
        merge: true,
      );

      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
