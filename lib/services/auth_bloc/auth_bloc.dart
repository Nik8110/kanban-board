import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/services/repo/auth_repo.dart';
import 'package:kanban_board_app/utils/const.dart';
import 'package:kanban_board_app/views/dashboard_screen.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SigninWithEmailPasswordEvent>(_signinWithEmail_Password);
    on<SignUpEvent>(_signInWithGoogle);
  }

  Future<void> _signinWithEmail_Password(
      SigninWithEmailPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Either<AppError, Map?>? res = await AuthRepo().signInWithEmailAndPassword(
        event.email!,
        event.password!,
        event.context!,
        isLogin: event.isLogin!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorSnackbar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        errorSnackbar("The account already exists for that email.");
      } else {
        errorSnackbar(e.message ?? "Email and password do not match");
      }
    } catch (e) {
      errorSnackbar(e.toString());
    } finally {
      emit(AuthInitial());
    }
  }

  Future<void> _signInWithGoogle(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Either<AppError, User> res = await AuthRepo()
          .signinWithGoogle(isLogin: event.isLogin, context: event.context);
      res.fold((l) {}, (r) {
        if (event.isLogin!) {
          Get.to(() => const DashboardScreen());
        } else {
          Get.to(() => const DashboardScreen());
        }
        emit(AuthInitial());
      });
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }
}
