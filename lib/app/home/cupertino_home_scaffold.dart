import 'package:flutter/material.dart';
import 'package:traken/app/home/tab_item.dart';
import 'package:flutter/cupertino.dart';
class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  const CupertinoHomeScaffold({Key key,@required this.currentTab, @required this.onSelectTab,@required this.widgetBuilder,@required this.navigatorKeys}) : super(key: key);
  final ValueChanged<TabItem> onSelectTab;
final Map<TabItem,WidgetBuilder> widgetBuilder;
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {

    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index)=>onSelectTab(TabItem.values[index]),
        ),
        tabBuilder:(context,index){
          final item=TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context)=>widgetBuilder[item](context),
          );
        }
    );

  }
  BottomNavigationBarItem _buildItem(TabItem tabItem)
  {
    final itemData=TabItemData.allTabs[tabItem];
    final color=currentTab==tabItem?Colors.indigo:Colors.grey;
    return BottomNavigationBarItem(
        icon: Icon(itemData.icon),
        label: itemData.title,backgroundColor: color
    );
  }
}
