import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traken/app/sign_in/email_sign_in_bloc.dart';
import 'package:traken/common_widgets/form_submit_button.dart';
import 'package:provider/provider.dart';
import 'package:traken/common_widgets/platform_exception_alert_dialog.dart';
import 'package:traken/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget  {
  EmailSignInFormBlocBased({@required this.bloc});
final EmailSignInBloc bloc;
static Widget create(BuildContext context)
{
  final AuthBase auth=Provider.of<AuthBase>(context);
  return Provider<EmailSignInBloc>(
    create: (context)=>EmailSignInBloc(auth: auth),
    child: Consumer<EmailSignInBloc>(
      builder: (context,bloc,_)=>EmailSignInFormBlocBased(bloc: bloc),

    ),
    dispose: (context,bloc)=>bloc.dispose(),
  );
}

  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }



  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('yes');
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _toggle() {
    widget.bloc.toggleFormType();


    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus=model.emailValidator.isValid(model.email)?_passwordFocus:_emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(EmailSignInModel model) {

    return [
      buildemailtextfield(model),
      SizedBox(height: 8.0),
      buildpasswordtextfieldmethod(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed:model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading?_toggle:null,
      ),
    ];
  }

  TextField buildpasswordtextfieldmethod(EmailSignInModel model) {

    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText ,
        enabled: model.isLoading==false,
      ),
      textInputAction: TextInputAction.done,
      obscureText: true,
      focusNode: _passwordFocus,
      onEditingComplete: _submit,
      onChanged:  widget.bloc.updatePassWord,

    );
  }

  TextField buildemailtextfield(EmailSignInModel model) {

    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading==false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocus,
      onEditingComplete:()=> _emailEditingComplete(model),
      onChanged:widget.bloc.updateEmail,

    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model =snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          ),
        );
      }
    );
  }
}
