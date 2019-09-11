import 'package:flutter/material.dart';
import 'package:flutterdemo/models/drill.dart';
//import 'package:flutter_image/network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DrillTabContainer extends StatelessWidget {
  const DrillTabContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Drill>>(
        future: Drill.fetchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              slivers: <Widget>[
                const SliverAppBar(
                  titleSpacing: 5.0,
                  pinned: false,
                  floating: true,
                  backgroundColor: Colors.white10,
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Oefeningen', style: TextStyle(fontSize: 13.0)),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1.2,
                    
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {

                      final imagePovider = CachedNetworkImageProvider((snapshot.data[index].imgUrl=="" || snapshot.data[index].imgUrl==null ? "https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg" : snapshot.data[index].imgUrl)
                      , errorListener: () => {}
                      );
                        //print (snapshot.data[index].imgUrl);
                        return  Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imagePovider, 
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(snapshot.data[index].title, 
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13,  fontWeight: FontWeight.normal, color:Colors.white)),
                            ],
                          ) 
                        );
                    },
                    childCount: snapshot.data.length // 216
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        } 
      )
    );
  }
}