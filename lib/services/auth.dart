import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
class fbUser {
  fbUser({@required this.photoUrl,@required this.displayName, @required this.uid});
  final String uid;
  final String photoUrl;
  final String displayName;

}

abstract class AuthBase {
  Stream<fbUser> get onAuthStateChanged;
  Future<fbUser> signInAnonymously();
  fbUser currentUser();
  Future<void> signOut();
  Future<fbUser> signInWithGoogle();
  Future<fbUser> signInWithFacebook();
  Future<fbUser>createUserWithEmail(String email , String password);
  Future<fbUser>signInWithEmail(String email , String password);


}

class Auth implements AuthBase {
  fbUser _userFromFirebase(User user) {
    if (user == null) return null;
    return fbUser(uid: user.uid,
    displayName: user.displayName,
    photoUrl: user.photoURL);
  }

  @override
  Stream<fbUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<fbUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }
@override
  Future<fbUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if(googleAuth.accessToken!=null && googleAuth.accessToken!=null){
      final authResult = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
      );
      return _userFromFirebase(authResult.user);
    }
      else {
        throw PlatformException(code: 'ERROR_MISSING_AUTH_USER',
            message: 'missing google auth token'
        );
      }
    }
    else
      {
        throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
        message: 'sign in aborted by user'
        );
      }
  }
  @override
  Future<fbUser> signInWithFacebook() async{
    final facebookLogin=FacebookLogin();
    final result=await facebookLogin.logInWithReadPermissions(['public_profile']);
    if(result.accessToken!=null){
      final authResult=await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(result.accessToken.token));
      return _userFromFirebase(authResult.user);
    }
    else{
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
          message: 'sign in aborted by user'
      );

    }

  }
  @override
  Future<fbUser>signInWithEmail(String email , String password) async{
    final authResult=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    _userFromFirebase(authResult.user);
  }
  @override
  Future<fbUser>createUserWithEmail(String email , String password) async{
    final authResult=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    _userFromFirebase(authResult.user);
  }

  @override
  fbUser currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn=GoogleSignIn();
    await googleSignIn.signOut();
    final facebookSignIn=FacebookLogin();
    await facebookSignIn.logOut();
    await _firebaseAuth.signOut();
  }
}
