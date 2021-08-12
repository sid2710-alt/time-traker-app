import 'dart:io';
import 'package:traken/app/home/home_page.dart';
import 'package:traken/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:traken/services/database.dart';
import '../app/home/jobs/jobs_page.dart';
import './sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<fbUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            fbUser user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<fbUser>.value(
              value: user,
              child: Provider<Database>(
                  create: (_)=>FirestoreDatabase(uid: user.uid),
                  child: HomePage()),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
