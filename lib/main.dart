import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import 'screens/sessions.dart';
import 'screens/drills.dart';

void main() {
  runApp(
    KettinglopersApp()
/*         ChangeNotifierProvider(
            builder: (context) => DrillList(), 
            child:KettinglopersApp()
        ) */
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
      color: Colors.yellow, 
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  MyAppBar(title: Text("Instellingen")
                  
                  ),
                  Expanded(
                    child:Container(
                      color: Colors.lightGreen,
                    )
                  ),
                ],
              ),
              DrillTabContainer(),
              SessionTabContainer(),

            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.settings),
                text: "Instellingen"
              ),
              Tab(
                icon: Icon(Icons.directions_run),
                text: "Oefeningen"
              ),
              Tab(
                icon: Icon(Icons.event_note),
                text: "Trainingen"
              ),

            ],
            labelColor: Colors.blue[700],
            unselectedLabelColor: Colors.blue[300],
            indicatorSize: TabBarIndicatorSize.tab
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}