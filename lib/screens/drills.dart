import 'package:flutter/material.dart';
import 'package:flutterdemo/models/drill.dart';
import 'package:flutter_image/network.dart';

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
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Oefeningen'),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0,
                    childAspectRatio: 1.2,
                    
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImageWithRetry(snapshot.data[index].imgUrl), 
                            // image: CachedNetworkImage(
                            //   imageUrl: snapshot.data[index].imgUrl,
                            //   placeholder: (context, url) => new CircularProgressIndicator(),
                            //   errorWidget: (context, url, error) => new Icon(Icons.error),
                            // ),
                            fit: BoxFit.cover),
                        ),
                        child: Text(snapshot.data[index].title, 
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13,  fontWeight: FontWeight.normal)),
                      );
                    }
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