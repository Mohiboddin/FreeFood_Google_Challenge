import 'package:flutter/material.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/main.dart';
import 'package:helpingworld/screens/history_screen.dart';
import 'package:helpingworld/user_data.dart';
import 'package:helpingworld/network_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userInfo;
  bool isInfoAvailable = false;

  @override
  void initState() {
    super.initState();
    getUserInfo().then((res) {
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        setState(() {
          userInfo = convert.jsonDecode(res.body);
          isInfoAvailable = true;
        });
      }
    });
  }

  Future getUserInfo() async {
    http.Response res = await get(
        '/profile?username=${userData.get(UserData.username) ?? username}');
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: isInfoAvailable
          ? Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                      ),
                      title: Text(
                        'User Name',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      subtitle: Text(
                        userInfo["username"],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    // ListTile(
                    //   leading: Icon(
                    //     Icons.mail_outline_outlined,
                    //     size: 40,
                    //   ),
                    //   title: Text(
                    //     'Email id',
                    //     style: TextStyle(
                    //       color: Colors.black45,
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     'bawaal@gmail.com',
                    //     style: TextStyle(color: Colors.black, fontSize: 20),
                    //   ),
                    // ),
                    ListTile(
                      leading: Icon(
                        Icons.add_call,
                        size: 40,
                      ),
                      title: Text(
                        'Phone',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      subtitle: Text(
                        userInfo["phone"],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.add,
                        size: 40,
                      ),
                      title: Text(
                        // TODO : It can be make dynamic
                        'Score',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      subtitle: Text(
                        '105',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.add_location_alt,
                        size: 40,
                      ),
                      title: Text(
                        'Address',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      subtitle: Text(
                        userInfo["address"],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HistoryScreen();
                          }));
                          print('Login tapped');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfileScreen();
                          }));
                          print('Login tapped');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: Text('Loading Profile ...'),
            ),
    );
  }
}
