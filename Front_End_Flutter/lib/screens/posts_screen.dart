import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpingworld/screens/history_screen.dart';
import 'package:helpingworld/utilities.dart';
import 'package:helpingworld/network_helper.dart';
import 'package:helpingworld/screens/post_details_screen.dart';
import 'dart:convert' as convert;
import 'package:helpingworld/screens/profile_screen.dart';
import 'package:helpingworld/widgets/dialogs.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Map<String, dynamic> location;
  List posts;
  bool isPostsAvailable = false;
  String count = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getLocation().then((value) {
      location = value;
      print(location);
      getPosts().then((res) {
        setState(() {
          if (res.statusCode == 200) {
            posts = convert.jsonDecode(res.body);
            count = '(${posts.length})';
          } else {
            posts = [];
          }
          isPostsAvailable = true;
        });
      });
    });
  }

  Future getPosts() async {
    var res = await get(
        '/need?longitude=${location['longitude']}&latitude=${location['latitude']}');
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'post');
          },
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.api),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HistoryScreen();
                  })).then((value) {
                    getPosts().then((res) {
                      if (res.statusCode == 200) {
                        setState(() {
                          posts = convert.jsonDecode(res.body);
                        });
                      }
                    });
                  });
                }),
            IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () async {
                  if (await isConnected()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }));
                  } else {
                    oneButtonDialog(
                        context: context,
                        text: 'Please connect to Internet',
                        onPressed: () {
                          Navigator.of(context).pop();
                        });
                  }
                }),
          ],
          title: Text('Needs around you $count'),
        ),
        body: isPostsAvailable
            ? (posts.length == 0)
                ? Center(
                    child: Text('There is no need around you'),
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PostDetailsScreen(post: post);
                          }));
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${post['plates']}'),
                            ),
                            title: Text(
                                '${post['username']} . ${post['food_type']} . ${getTime(post['created_at'])}'),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${post['address']}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(getDate(post['created_at']))
                                ]),
                          ),
                        ),
                      );
                    })
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
