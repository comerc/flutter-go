/**
 * Created with Android Studio.
 * User: 三帆
 * Date: 16/01/2019
 * Time: 11:16
 * email: sanfan.hx@alibaba-inc.com
 * tartget:  app首页
 */



import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'first_page.dart';
import 'widget_page.dart';
//import 'package:flutter_go/views/welcome_page/fourth_page.dart';
import 'collection_page.dart';
import '../routers/application.dart';
import '../common/provider.dart';
import '../model/widget.dart';
import '../widgets/index.dart';
import 'package:flutter_go/components/search_input.dart';

const int ThemeColor = 0xFFC91B3A;

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<AppPage>
    with SingleTickerProviderStateMixin {
  WidgetControlModel widgetControl = new WidgetControlModel();
  TabController controller;
  bool isSearch = false;
  String data = '无';
  String data2ThirdPage = '这是传给ThirdPage的值';
  String appBarTitle = tabData[0]['text'];
  static List tabData = [
    {'text': '业界动态', 'icon': new Icon(Icons.language)},
    {'text': 'WIDGET', 'icon': new Icon(Icons.extension)},
    {'text': '组件收藏', 'icon': new Icon(Icons.star)},
    {'text': '关于手册', 'icon': new Icon(Icons.favorite)}
  ];

  List<Widget> myTabs = [];

  @override
  void initState() {
    super.initState();
    controller = new TabController(
        initialIndex: 0, vsync: this, length: 4); // 这里的length 决定有多少个底导 submenus
    for (int i = 0; i < tabData.length; i++) {
      myTabs.add(new Tab(text: tabData[i]['text'], icon: tabData[i]['icon']));
    }
    controller.addListener(() {
      if (controller.indexIsChanging) {
        _onTabChange();
      }
    });
    Application.controller = controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onWidgetTap(WidgetPoint widgetPoint, BuildContext context) {
    List widgetDemosList = new WidgetDemoList().getDemos();
    String targetName = widgetPoint.name;
    String targetRouter = '/category/error/404';
    widgetDemosList.forEach((item) {
      if (item.name == targetName) {
        targetRouter = item.routerName;
      }
    });
    Application.router.navigateTo(context, "$targetRouter");
  }

  Widget buildSearchInput(BuildContext context) {
    return new SearchInput((value) async {
      if (value != '') {
        List<WidgetPoint> list = await widgetControl.search(value);

        return list
            .map((item) => new MaterialSearchResult<String>(
          value: item.name,
          text: item.name,
          onTap: () {
            onWidgetTap(item, context);
          },
        ))
            .toList();
      } else {
        return null;
      }
    }, (value) {}, () {});
  }

  @override
  Widget build(BuildContext context) {
    var db = Provider.db;

    return new Scaffold(
      appBar: new AppBar(title: buildSearchInput(context)),
      body: new TabBarView(controller: controller, children: <Widget>[
        new FirstPage(),
        new WidgetPage(db),
        new CollectionPage(),
        Container(
          child: Center(
            child: Text("开发中"),
          ),
        )
      ]),
      bottomNavigationBar: Material(
        color: const Color(0xFFF0EEEF), //底部导航栏主题颜色
        child: SafeArea(
          child: Container(
            height: 65.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFd0d0d0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(-1.0, -1.0),
                ),
              ],
            ),
            child: TabBar(
              controller: controller,
              indicatorColor: Theme.of(context).primaryColor, //tab标签的下划线颜色
              // labelColor: const Color(0xFF000000),
              indicatorWeight: 3.0,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: const Color(0xFF8E8E8E),
              tabs: <Tab>[
                Tab(text: '业界动态', icon: Icon(Icons.language)),
                Tab(text: '组件', icon: Icon(Icons.extension)),
                Tab(text: '组件收藏', icon: Icon(Icons.favorite)),
                Tab(text: '关于手册', icon: Icon(Icons.line_weight)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabChange() {
    if (this.mounted) {
      this.setState(() {
        appBarTitle = tabData[controller.index]['text'];
      });
    }
  }
}