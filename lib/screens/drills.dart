import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hardloopscholing/models/drill_list.dart';
import 'package:hardloopscholing/models/drill.dart';
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

  void playYoutube(BuildContext context, String id) {
      //apiKey: "AIzaSyC825Vks1pwx2DW4Iv4o3I6C1q7EoxJDVY",
    // AIzaSyC825Vks1pwx2DW4Iv4o3I6C1q7EoxJDVY
    FlutterYoutube.playYoutubeVideoById(
      apiKey: "AIzaSyC825Vks1pwx2DW4Iv4o3I6C1q7EoxJDVY",
      videoId: id,
      autoPlay: true, //default falase
      fullScreen: true //default false
    );

  }

  OverlayEntry overlayEntry;
  void showDetails(BuildContext context, List drills, int index) {

    final Drill drill = drills[index];
    final bool hasNextDrill = drills.length > (index+1);
    final bool hasPrevDrill = index>0;
    final bool hasVideo =!(drill.videoUrl == '' || drill.videoUrl == null);

    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    //"https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg"
    final bool hasImage = !(drill.imgUrl==null || drill.imgUrl=="" || drill.imgUrl.contains("kettinglopers"));
    final String imgUrl = hasImage ? drill.imgUrl : "https://api.kettinglopers.nl/images/"+drill.tags[0].toString().toLowerCase().replaceAll(' ', '-')+".png?ts=0000";
    final imageProvider = CachedNetworkImageProvider(imgUrl, errorListener: () => {} );
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
            print("dismis..");
            
            this.overlayEntry.remove();
            if(direction == DismissDirection.startToEnd && hasPrevDrill){
            print(drill);
              showDetails(context, drills, index-1);
            } else if(direction == DismissDirection.endToStart && hasNextDrill){
            print(drill);
              showDetails(context, drills, index+1);
            }
          },
          child: AnimatedContainer(
            curve: Curves.linear,
            duration: Duration(milliseconds: 500),
            child: Card(
              color: Colors.black,
              margin: EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ButtonTheme.bar( // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          hasPrevDrill==false ? null : RaisedButton(
                            color: Colors.white,
                            child: Text(" << "),
                            onPressed: () { 
                                this.overlayEntry.remove();
                                showDetails(context, drills, index-1);
                             },
                          ),  
                          drill.videoUrl == '' || drill.videoUrl == null ? null : RaisedButton(
                            color: Colors.white,
                            child: Text("AFSPELEN"),
                            //icon: Icon(Icons.play_circle_outline, size: 40.0,),
                            onPressed: () { playYoutube(context, drill.videoUrl); },
                          ),
                          RaisedButton(
                            color: Colors.white,
                            child: const Text('TERUG'),
                            onPressed: () { this.overlayEntry.remove(); },
                          ),
                          hasNextDrill==false ? null : RaisedButton(
                            color: Colors.white,
                            child: Text(" >> "),
                            onPressed: () { 
                                this.overlayEntry.remove();
                                showDetails(context, drills, index+1);
                             },
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: 250.0,
                        //margin: EdgeInsets.all(15.0),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider, 
                            fit: hasImage ? BoxFit.contain : BoxFit.fitWidth
                          ),
                        ),
                      ),
                      onTap: () => playYoutube(context, drill.videoUrl)
                    ), 
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: drill.tags.map((item) => 
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item,
                                style: TextStyle(color: Colors.white38, fontSize: 20.0),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          )).toList(),
                        
                        ),
                      ),
  
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0, top:10.0),
                      color: Colors.black,
                      child: ListTile(
                        leading:null,
                        title: Text(drill.title == null ? '' : drill.title, style: TextStyle(color: Colors.white) ),
                        subtitle: Text(drill.description == null ? '' : drill.description, style: TextStyle(color: Colors.white70))
                      ),
                    ), 
             
                    hasVideo ? FloatingActionButton.extended(
                      label: Text('Afspelen'),
                      icon: Icon(Icons.play_circle_filled),
                      //backgroundColor: Colors.,
                      onPressed: () => playYoutube(context, drill.videoUrl)
                    ) : Container(),
                    ],
                  ),
              )
              ),
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
                        key: PageStorageKey('key'),
                        slivers: <Widget>[
                          SliverAppBar(
                            titleSpacing: 1.0,
                            pinned: true,
                            floating: true,
                            snap: true,
                            actions: <Widget>[

                            ],
                          ),

                          SliverGrid(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 2.0,
                              childAspectRatio: 1.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final bool hasImage = !(snapshot.data[index].imgUrl==null || snapshot.data[index].imgUrl=="" || snapshot.data[index].imgUrl.contains("kettinglopers"));
                                final String imgUrl = hasImage ? snapshot.data[index].imgUrl : "https://api.kettinglopers.nl/images/"+snapshot.data[index].tags[0].toString().toLowerCase().replaceAll(' ', '-')+".png?ts=0000";
                                final imagePovider = CachedNetworkImageProvider((hasImage ? imgUrl : imgUrl)
                                , errorListener: () => {}
                                );
                                  //print (snapshot.data[index].imgUrl);
                                  return  InkWell(
                                    child: Container(
                                      //alignment: Alignment.topCenter,
                                      //padding: const EdgeInsets.all(0.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: imagePovider, 
                                        fit: hasImage ? BoxFit.cover : BoxFit.fitWidth,
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            padding: EdgeInsets.all(5.0),
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.4)
                                            ),  
                                            child: Text(snapshot.data[index].title, 
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 13,  fontWeight: FontWeight.normal, color:Colors.white)),
                                          ),
                                        ],
                                      ) 
                                    ),
                                    onTap: () => showDetails(context, snapshot.data, index)
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
            //color: Colors.white60,
            child: Tags( 
              direction: Axis.horizontal,
              horizontalScroll: true,
              itemCount: Provider.of<DrillList>(context).tags.length, 
              itemBuilder: (int index){ 
                  final item = Provider.of<DrillList>(context).tags[index];
                  return ItemTags(
                    activeColor: Colors.white,
                    textActiveColor: Colors.black26,
                    textColor: Colors.black,
                    index: index, 
                    title: item,
                    textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                    borderRadius: BorderRadius.circular(5.0),
                    onPressed: (itm) => Provider.of<DrillList>(context).toggleTagFilter(itm.title),
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
