import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traken/common_widgets/avatar.dart';
import 'package:traken/common_widgets/platform_alert_dialog.dart';
import 'package:traken/services/auth.dart';
class AccountPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<fbUser>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[

          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),

    );
  }
  Widget _buildUserInfo(fbUser user)
  {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8,),
        if(user.displayName!=null)
          Text(user.displayName,style: TextStyle(color: Colors.white),),
        SizedBox(height: 8,),
      ],
    );
  }
  }

