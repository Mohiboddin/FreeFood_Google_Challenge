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
import 'package:helpingworld/widgets/dialogs.dart';
import 'package:helpingworld/widgets/my_button.dart';
import 'package:helpingworld/screens/mapview.dart';

class GivenScreen extends StatefulWidget {
  @override
  _GivenScreenState createState() => _GivenScreenState();
}

class _GivenScreenState extends State<GivenScreen> {
  List givingData;
  bool isGivingDataAvailable = false;
  int otp = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getGivings().then((res) {
      setState(() {
        if (res.statusCode == 200) {
          givingData = convert.jsonDecode(res.body);
        } else {
          givingData = [];
        }
        isGivingDataAvailable = true;
      });
    });
  }

  Future getGivings() async {
    var res = await get(
        '/relation?username=${userData.get(UserData.username) ?? username}');
    return res;
  }

  @override
  Widget build(BuildContext context) {
    print(givingData);
    return Scaffold(
        body: isGivingDataAvailable
            ? (givingData.length == 0)
                ? Center(child: Text('You have not accepted any request'))
                : ListView.builder(
                    itemCount: givingData.length,
                    itemBuilder: (context, index) {
                      var p = givingData[index];
                      return GestureDetector(
                        child: Card(
                          color: (p['taker_accepted'] == 1)
                              ? Colors.lightBlueAccent
                              : Colors.white,
                          child: ListTile(
                            onTap: () async {
                              twoButtonDialog(
                                  ybtntxt: 'Location',
                                  nbtntxt: 'Decline',
                                  context: context,
                                  text: 'What do you want to do ?',
                                  onPressedYes: () async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MapView(
                                        latitude: p["latitude"],
                                        longitude: p["longitude"],
                                      );
                                    }));
                                  },
                                  onPressedNo: () async {
                                    Map<String, dynamic> body = {
                                      "username":
                                          userData.get(UserData.username) ??
                                              username,
                                      "post_id": p["post_id"],
                                    };
                                    http.Response res =
                                        await delete('/relation', body: body);
                                    Navigator.pop(context);
                                  });
                            },
                            onLongPress: () async {
                              if (p["taker_accepted"] == 1) {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (otpString) {
                                            if (otpString.isNotEmpty) {
                                              this.otp = int.parse(otpString);
                                            }
                                          },
                                        ),
                                        content: MyButton(
                                          text: 'Verify OTP',
                                          onPressed: () async {
                                            print('button pressed');
                                            Map<String, dynamic> body = {
                                              "post_id": p["post_id"],
                                              "otp": otp
                                            };
                                            print(body);
                                            http.Response res =
                                                await post('/otp', body);
                                            if (res.statusCode == 201) {
                                              getGivings().then((value) {
                                                setState(() {
                                                  givingData.removeWhere(
                                                      (post) =>
                                                          post["post_id"] ==
                                                          p["post_id"]);
                                                });
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              setState(() {
                                                print('showing snakcbar');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Incorrect OTP, try again')));
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    });
                              }
                            },
                            leading: CircleAvatar(
                              child: Text('${p['plates']}'),
                            ),
                            title: Text('${p['taker']} . ${p['food_type']}'),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${p['phone']}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(getDate(p['created_at']))
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
