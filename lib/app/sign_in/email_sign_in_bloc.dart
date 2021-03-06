import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:traken/app/sign_in/email_sign_in_model.dart';
import 'package:traken/services/auth.dart';

class EmailSignInBloc{
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController=StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream=>_modelController.stream;
  EmailSignInModel _model=EmailSignInModel();
  void dispose(){
    _modelController.close();
  }
  Future<void> submit() async {
updateWith(submitted: true,isLoading: true);
    try {

      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(_model.email, _model.password);
      } else
        await auth.createUserWithEmail(_model.email, _model.password);

    }catch (e) {
      updateWith(isLoading: false);
     rethrow;
    }

  }
  void toggleFormType(){
  final formType= _model.formType== EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType: formType,
    );
  }
  void updateEmail(String email)=>updateWith(email:email);
  void updatePassWord(String password)=>updateWith(password: password);
  void updateWith({
  String email,
    String password,
  EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
}){_model=_model.copyWith(
    email: email,
    formType: formType,
    password: password,
    isLoading: isLoading,
      submitted: submitted,
  );
_modelController.add(_model);

  }
}