import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kanban_board_app/utils/const.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';
import 'package:kanban_board_app/views/dashboard_screen.dart';

class AuthRepo {
  static final AuthRepo _singleton = AuthRepo._internal();

  factory AuthRepo() {
    return _singleton;
  }

  AuthRepo._internal();

  Future<Either<AppError, Map?>?> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context, {
    bool isLogin = false,
  }) async {
    UserCredential? userCredential;
    Either<AppError, Map<dynamic, dynamic>>? res;
    if (isLogin) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        userCredential = value;
        Get.off(() => const DashboardScreen());
        successSnackbar('Login Successful');
        LocalStorageUtil.write("userId", userCredential!.user!.uid);
      });
    } else {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        userCredential = value;
        CollectionReference toDO =
            FirebaseFirestore.instance.collection('users');
        toDO.add(
            {"email": value.user?.email ?? "", "uid": value.user?.uid ?? ""});

        Get.off(() => const DashboardScreen());
        successSnackbar('Register Successful');
        LocalStorageUtil.write("userId", userCredential!.user!.uid);
      });
    }
    print(userCredential);
    return res;
  }

  Future<Either<AppError, User>> signinWithGoogle({isLogin, context}) async {
    Either<AppError, User>? res;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        CollectionReference toDO =
            FirebaseFirestore.instance.collection('users');
        toDO.add({
          "email": userCredential.user?.email ?? "",
          "uid": userCredential.user?.uid ?? ""
        });
      }
      LocalStorageUtil.write("userId", userCredential.user!.uid);
      print('!!!!!!!!!!!${userCredential}');
      return Right(userCredential.user!);
    } catch (e) {
      errorSnackbar("Google authorization unsuccessful.");
      return Left(AppError(
          title: "Firebase Error", description: "Something Went Wrong!"));
    }
  }
}

class AppError {
  final String title;
  final String description;

  AppError({this.title = "", this.description = ""});

  @override
  int get hashCode => title.hashCode ^ description.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppError &&
          other.title == title &&
          other.description == description);

  void log([String? eventName]) {
    if (!kDebugMode && eventName != null) {
      /// Log to crashlytics
      //   FirebaseCrashlytics.instance.recordError(
      //       Exception(title), StackTrace.fromString(eventName),
      //       reason: description);
    }
  }
}
