
import 'package:traken/app/sign_in/validiators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPassword{
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

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
  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  })
  {
    return EmailSignInModel(
      email: email ??this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,

    );
  }
}

