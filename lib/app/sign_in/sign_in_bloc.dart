import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:traken/services/auth.dart';

class SignInBloc{
  SignInBloc({@required this.auth,@required this.isLoading});
    final AuthBase auth;
    final ValueNotifier<bool> isLoading;

  Future<fbUser>_signIn(Future<fbUser> Function() signInMethod) async
  {
    try{
      isLoading.value=true;
      return await signInMethod();
    }
    catch(e){
      isLoading.value=false;
      rethrow;


    }

  }

  Future<fbUser> signInAnonymously() async=>await _signIn(auth.signInAnonymously);
  Future<fbUser> signInWithGoogle() async=> await _signIn(auth.signInWithGoogle);
  Future<fbUser> signInWithFacebook()async=> await _signIn(auth.signInWithFacebook);
}