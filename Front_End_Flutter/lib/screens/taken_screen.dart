import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:helpingworld/screens/login_screen.dart';
import 'package:helpingworld/user_data.dart';
import 'package:helpingworld/utilities.dart';
import 'package:helpingworld/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/main.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/screens/post_details_screen.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:helpingworld/screens/response_screen.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/widgets/dialogs.dart';

class TakenScreen extends StatefulWidget {
  @override
  _TakenScreenState createState() => _TakenScreenState();
}

class _TakenScreenState extends State<TakenScreen> {
  Map<String, dynamic> location;
  List takingData;
  List responses;
  bool isTakingDataAvailable = false;

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
          var data = convert.jsonDecode(res.body);
          takingData = data['your_takings'];
          responses = data['got_responses'];
          isTakingDataAvailable = true;
          print(takingData);
          print(responses);
          // isPostsAvailable = true;
        });
      });
    });
  }

  Future getPosts() async {
    Map<String, String> body = {
      "username": userData.get(UserData.username) ?? username
    };
    var res = await post('/taking', body);
    return res;
  }

  Future getResponses(int id) async {
    var res = await get(
        '/taking?post_id=$id&username=${userData.get(UserData.username) ?? username}');
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isTakingDataAvailable
            ? takingData.isEmpty
                ? Center(
                    child: Text('You did not post any request'),
                  )
                : ListView.builder(
                    itemCount: takingData.length,
                    itemBuilder: (context, index) {
                      var post = takingData[index];
                      return GestureDetector(
                        onTap: () async {
                          http.Response res =
                              await getResponses(post["post_id"]);
                          if (res.statusCode == 200) {
                            print(res.body);
                            var responses = convert.jsonDecode(res.body);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ResponseScreen(
                                responses: responses,
                                id: post["post_id"],
                              );
                            }));
                          } else if (res.statusCode == 401) {
                            oneButtonDialog(
                                context: context,
                                text: "No response on this request",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                });
                          }
                        },
                        child: Card(
                          color: (responses.contains(post["post_id"]))
                              ? Colors.lightBlueAccent
                              : Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${post['no_of_people']}'),
                            ),
                            title: Text(
                                '${post['food_type']} . ${getTime(post['created_at'])}'),
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
