import 'package:flutter/cupertino.dart';
import 'package:traken/app/sign_in/validiators.dart';
import 'package:traken/services/auth.dart';
import 'email_sign_in_model.dart';
import 'package:flutter/foundation.dart';
class EmailSignInChangeModel with EmailAndPassword, ChangeNotifier{
  EmailSignInChangeModel({
    @required this.auth, 
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
   String email;
   final AuthBase auth;
   String password;
   EmailSignInFormType formType;
   bool isLoading;
   bool submitted;
  Future<void> submit() async {
    updateWith(submitted: true,isLoading: true);
    try {

      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(email, password);
      } else
        await auth.createUserWithEmail(email, password);

    }catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }

  }
  String get primaryButtonText{
    return formType == EmailSignInFormType.signIn ? 'sign In' : 'Create Account';
  }
  String get secondaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Need an account?register'
        : 'Have an account?signIn';
  }
  bool get canSubmit{
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) && !isLoading;
  }
  String get passwordErrorText{
    bool showErrorText=
        submitted && !passwordValidator.isValid(password);
    return showErrorText?invalidPasswordErrorText:null;
  }
  String get emailErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText?invalidEmailErrorText:null;
  }
  void toggleFormType(){
    final formType= this.formType== EmailSignInFormType.signIn
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
  void updatePassword(String password)=>updateWith(password: password);
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  })
  {

     this.email= email ?? this.email;
      this.password= password ?? this.password;
      this.formType= formType ?? this.formType;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;
      notifyListeners();


  }
}

