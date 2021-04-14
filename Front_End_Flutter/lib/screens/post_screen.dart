import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:helpingworld/screens/profile_screen.dart';
import 'package:helpingworld/screens/signup_screen.dart';
import 'package:helpingworld/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/network_helper.dart';
import 'package:helpingworld/main.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/utilities.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic> location;
  List<String> foodType = ['Any', 'Veg', 'Non-veg'];
  String selectedFoodType;
  List<String> position = ['Yes', 'No'];
  String selectedPosition;
  // List<String> pickingType = ['Self Pickup', 'Delivery'];
  // String selectedPickingType;
  // List<int> expireLimits = [1, 2, 3, 4, 5, 6, 7];
  // int selectedValidity;

  TextEditingController platesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getLocation().then((value) {
      location = value;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    selectedFoodType = foodType[0];
    selectedPosition = position[0];
    // selectedPickingType = pickingType[0];
    // selectedValidity = expireLimits[0];
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset(
              'assets/images/loginimage.png',
              height: 200,
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(128, 128, 128, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Food type : ',
                        style: kTextSyle,
                      ),
                      DropdownButton(
                          value: selectedFoodType,
                          items: foodType
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: kTextSyle,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFoodType = value;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: platesController,
                onSubmitted: (value) {
                  print(value);
                },
                decoration: InputDecoration(
                  labelText: 'Number of Plates',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1), fontSize: 20),
                  hintText: 'Enter number of plates ...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            // Padding(
            //   padding:
            //       EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Color.fromRGBO(128, 128, 128, 1),
            //       ),
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     child: Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Select Picking Type : ',
            //             style: kTextSyle,
            //           ),
            //           DropdownButton(
            //               value: selectedPickingType,
            //               items: pickingType
            //                   .map<DropdownMenuItem<String>>((String value) {
            //                 return DropdownMenuItem<String>(
            //                   value: value,
            //                   child: Text(
            //                     value,
            //                     style: kTextSyle,
            //                   ),
            //                 );
            //               }).toList(),
            //               onChanged: (value) {
            //                 setState(() {
            //                   selectedPickingType = value;
            //                 });
            //               })
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(128, 128, 128, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Is your Position fixed ?',
                        style: kTextSyle,
                      ),
                      DropdownButton(
                          value: selectedPosition,
                          items: position
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: kTextSyle,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPosition = value;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding:
            //       EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Color.fromRGBO(128, 128, 128, 1),
            //       ),
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     child: Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Expire request in : ',
            //             style: kTextSyle,
            //           ),
            //           DropdownButton(
            //               value: selectedValidity,
            //               items: expireLimits
            //                   .map<DropdownMenuItem<int>>((int value) {
            //                 return DropdownMenuItem<int>(
            //                   value: value,
            //                   child: Text(
            //                     '$value day${(selectedValidity != 1) ? 's' : ''}',
            //                     style: kTextSyle,
            //                   ),
            //                 );
            //               }).toList(),
            //               onChanged: (value) {
            //                 setState(() {
            //                   selectedValidity = value;
            //                 });
            //               })
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor,
                onPressed: () async {
                  Map<String, dynamic> body = {
                    "username": userData.get(UserData.username) ?? username,
                    "food_type": selectedFoodType,
                    "no_of_people": platesController.text,
                    // "picking_type": selectedPickingType,
                    // "validity": selectedValidity,
                    "longitude": location['longitude'],
                    "latitude": location['latitude'],
                    "address": location['address'],
                    "fixed_position": selectedPosition,
                  };

                  http.Response res = await post('/need', body);
                  if (res.statusCode == 201) {
                    Navigator.pushNamed(context, 'posts');
                  }
                  print('Login tapped');
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
