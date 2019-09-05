import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              DrillTabContainer(),
              SessionTabContainer(),
              Container(
                color: Colors.lightGreen,
              )
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.directions_run),
                text: "Oefeningen"
              ),
              Tab(
                icon: Icon(Icons.event_note),
                text: "Trainingen"
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: "Instellingen"
              )
            ],
            //labelColor: Colors.yellow,
            unselectedLabelColor: Colors.blue[100],
            indicatorSize: TabBarIndicatorSize.tab
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}