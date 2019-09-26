import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

class SettingsTabContainer extends StatelessWidget {

  final List<String>tags = [ "Warming uuup", "Loopscholing", "Core", "Kracht","lichaamsspanning"];
  SettingsTabContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Tags( 
            direction: Axis.horizontal,
            horizontalScroll: true,
            itemCount: tags.length, 
            itemBuilder: (int index){ 
                final item = tags[index];
                return ItemTags(index: index, title: item);
            }
          )
        ),
        Container(
          child: Tags( 
            direction: Axis.horizontal,
            horizontalScroll: true,
            itemCount: tags.length, 
            itemBuilder: (int index){ 
                final item = tags[index];
                return ItemTags(index: index, title: item);
            }
          )
        ),
      ]
    );
  }
}