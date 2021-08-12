import 'package:flutter/material.dart';
import 'package:traken/app/home/account/account_page.dart';
import 'package:traken/app/home/cupertino_home_scaffold.dart';
import 'package:traken/app/home/entries/entries_page.dart';
import 'tab_item.dart';
import 'jobs/jobs_page.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab=TabItem.jobs;
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys={
TabItem.jobs:GlobalKey<NavigatorState>(),
 TabItem.entries:GlobalKey<NavigatorState>(),
  TabItem.account:GlobalKey<NavigatorState>(),
  };
  Map<TabItem, WidgetBuilder> get widgetBuilder
  {
    return
      {
        TabItem.jobs:(_)=>JobsPage(),
        TabItem.entries:(context)=>EntriesPage.create(context),
        TabItem.account:(_)=>AccountPage(),
      };
  }
 void _select(TabItem tabItem)
 {
   setState(() {
     if(tabItem==_currentTab)
       {
         navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
       }
     else {
       _currentTab = tabItem;
     }
   });
 }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async=>!await navigatorKeys[_currentTab].currentState.maybePop() ,
      child: CupertinoHomeScaffold(currentTab: _currentTab, onSelectTab:_select,widgetBuilder: widgetBuilder,navigatorKeys: navigatorKeys,
      ),
    );
  }
}
