
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/models/drill_list.dart';
import 'package:flutterdemo/models/drill.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tags/tag.dart';
import 'package:flutter_youtube/flutter_youtube.dart';


/*             child: InkWell( 
              child: Text('details:'+drill.videoUrl),
              onTap: () => this.overlayEntry.remove()
            ), */
class DrillTabContainer extends StatelessWidget {
  DrillTabContainer({Key key, drills}) : super(key: key);

  void playYoutube(String id) {
    // AIzaSyC825Vks1pwx2DW4Iv4o3I6C1q7EoxJDVY
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyC825Vks1pwx2DW4Iv4o3I6C1q7EoxJDVY",
      videoUrl: "https://www.youtube.com/watch?v="+id,
      autoPlay: true, //default falase
      fullScreen: true //default false
    );
  }

  OverlayEntry overlayEntry;
  void showDetails(BuildContext context, Drill drill, CachedNetworkImageProvider imageProvider) {

    print("play...");
    OverlayState overlayState = Overlay.of(context);
    this.overlayEntry = OverlayEntry(
      opaque: true,
      builder: (BuildContext context) => Positioned(
        left: 0.0,
        top:20.0,
        height: MediaQuery.of(context).size.height-20.0,
        width: MediaQuery.of(context).size.width,
        child: Dismissible(
          background: Container(color: Colors.transparent),
          key: Key(drill.title),
          onDismissed: (direction) {
            this.overlayEntry.remove();
          },
          child: Card(
            color: Colors.black,
            margin: EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    child: ListTile(
                      leading:null,
                      title: Text(drill.title == null ? '' : drill.title, style: TextStyle(color: Colors.white) ),
                      subtitle: Text(drill.description == null ? '' : drill.description, style: TextStyle(color: Colors.white70) ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 250.0,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () => playYoutube(drill.videoUrl)
                  ),
                  ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        drill.videoUrl == '' || drill.videoUrl == null ? null : IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.play_circle_outline, size: 40.0,),
                          onPressed: () { playYoutube(drill.videoUrl); },
                        ),
                        FlatButton(
                          child: const Text('SLUITEN'),
                          onPressed: () { this.overlayEntry.remove(); },
                        ),
                      ],
                    ),
                  )],
                ),
            )
            ),
        )
        )            
      );
      overlayState.insert(overlayEntry);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Consumer<DrillList>(
          builder: (context, drills, child) {
            return Container(
              child: Container(
                child: FutureBuilder<List<Drill>>(
                  future: Provider.of<DrillList>(context).fetchAllCached(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            titleSpacing: 1.0,
                            pinned: true,
                            floating: true,
                            snap: false,
                            actions: <Widget>[

                            ],
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
                                  return  InkWell(
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: imagePovider, 
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(snapshot.data[index].title, 
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13,  fontWeight: FontWeight.normal, color:Colors.white)),
                                        ],
                                      ) 
                                    ),
                                    onTap: () => showDetails(context, snapshot.data[index], imagePovider)
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
            ),
          );
        }),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(top:22),
            color: Colors.white60,
            child: Tags( 
              direction: Axis.horizontal,
              horizontalScroll: true,
              itemCount: Provider.of<DrillList>(context).tags.length, 
              itemBuilder: (int index){ 
                  final item = Provider.of<DrillList>(context).tags[index];
                  return ItemTags(
                    index: index, 
                    title: item,
                    onPressed: (itm) => Provider.of<DrillList>(context).addTagFilter(itm.title),
                    //onRemoved: () => Provider.of<DrillList>(context).removeTagFilter(item[index])
                  );
              },
            ),
          ),
        ),


      ],
    );
  }
}
