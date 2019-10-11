import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/sessions.dart';
import 'screens/drills.dart';
import 'screens/settings.dart';
import 'models/drill_list.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => DrillList())
      ],
      child: KettinglopersApp(),
    ),
  );
}

class MyAppBar extends PreferredSize {
  MyAppBar({Key key, Widget title}) : super(
    key: key,
    preferredSize: Size.fromHeight(30),
    child: AppBar(
      title: title,
      // maybe other AppBar properties
    ),
  );
}

class KettinglopersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kettinglopers",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        canvasColor: Colors.black,
        buttonColor: Colors.deepOrange
        
      ),
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          body: TabBarView(
            children: [              
              DrillTabContainer(),
              //SessionTabContainer(),
              //SettingsTabContainer(),
            ],
          ),
           bottomNavigationBar: TabBar(
            tabs: [

              Tab(
                //icon: Icon(Icons.directions_run),
                text: "Oefeningen"
              ), 
/*               Tab(
                //icon: Icon(Icons.event_note),
                text: "Trainingen"
              ), */
/*               Tab(
                //icon: Icon(Icons.settings),
                text: "Instellingen"
              ), */
            ],
            //labelColor: Colors.blue[700],
            //unselectedLabelColor: Colors.blue[300],
            indicatorSize: TabBarIndicatorSize.tab
          ), 
          //backgroundColor: Colors.white,
        ),
      ),
    );
  }
}