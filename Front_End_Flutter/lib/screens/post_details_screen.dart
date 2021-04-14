import 'package:flutter/material.dart';
import 'package:helpingworld/main.dart';
import 'package:helpingworld/screens/history_screen.dart';
import 'package:helpingworld/utilities.dart';
import 'package:helpingworld/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/network_helper.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/screens/mapview.dart';
import 'package:helpingworld/widgets/dialogs.dart';

class PostDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  PostDetailsScreen({@required this.post});

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var p = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: Text('Need'),
      ),
      body: Column(
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
                  'Name',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                subtitle: Text(
                  p['username'],
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.accessibility,
                  size: 40,
                ),
                title: Text(
                  'Number of People',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                subtitle: Text(
                  '${p['plates']}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_shopping_cart,
                  size: 40,
                ),
                title: Text(
                  'Food type',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                subtitle: Text(
                  p['food_type'],
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              ListTile(
                  leading: Icon(
                    Icons.add_location_alt,
                    size: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Time'), Text(getTime(p['created_at']))],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text('Place')),
                      Expanded(
                        flex: 4,
                        child: Text(
                          p['address'],
                          maxLines: 3,
                        ),
                      )
                    ],
                  )),
              ListTile(
                  leading: Icon(
                    Icons.phone,
                    size: 40,
                  ),
                  title: Text('Phone'),
                  subtitle: Text(p['phone'])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MapView(
                        latitude: p["latitude"],
                        longitude: p["longitude"],
                      );
                    }));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    Map<String, dynamic> body = {
                      "username": userData.get(UserData.username) ?? username,
                      "post_id": p["id"]
                    };
                    http.Response res = await post('/relation', body);
                    if (res.statusCode == 201) {
                      Navigator.pop(context);
                    } else if (res.statusCode == 404) {
                      oneButtonDialog(
                          context: context,
                          text: "You can't accept this request",
                          onPressed: () {
                            Navigator.of(context).pop();
                          });
                    } else {
                      oneButtonDialog(
                          context: context,
                          text: "Some error occurred, try again",
                          onPressed: () {
                            Navigator.of(context).pop();
                          });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Approve',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
