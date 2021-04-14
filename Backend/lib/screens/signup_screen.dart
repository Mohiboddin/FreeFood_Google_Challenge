import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:helpingworld/screens/login_screen.dart';
import 'package:helpingworld/utilities.dart';
import 'package:helpingworld/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/main.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/user_data.dart';
import 'package:helpingworld/widgets/dialogs.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Map<String, dynamic> location;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool invalidUsername = false;
  bool invalidNumber = false;
  List validChar = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    ' '
  ];
  List validNum = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getLocation().then((value) {
      location = value;
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Color.fromRGBO(21, 18, 135, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                    print('login tapped tapped');
                  },
                  child: Opacity(
                    opacity: 0.3,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/loginimage.png',
                height: 200,
              ),
            ),
            Center(
              child: Text(
                'We will use GPS during Operations',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: TextField(
                controller: usernameController,
                onChanged: (username) {
                  setState(() {
                    for (int i = 0; i < username.length; i++) {
                      if (!validChar.contains(username[i].toLowerCase())) {
                        invalidUsername = true;
                      } else {
                        invalidUsername = false;
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1), fontSize: 20),
                  hintText: 'Type username ...',
                  errorText: invalidUsername ? 'Invalid username' : null,
                  errorStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: TextField(
                controller: passwordController,
                onSubmitted: (value) {
                  print(value);
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1), fontSize: 20),
                  hintText: 'Type your Password ...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: TextField(
                controller: phoneController,
                onChanged: (phone) {
                  setState(() {
                    for (int i = 0; i < phone.length; i++) {
                      if (!validNum.contains(phone[i])) {
                        invalidNumber = true;
                      } else {
                        invalidNumber = false;
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1), fontSize: 20),
                  hintText: 'Type your phone number ...',
                  errorText: invalidNumber ? 'Invalid number' : null,
                  errorStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor,
                onPressed: () async {
                  if (phoneController.text.length != 10) {
                    setState(() {
                      invalidNumber = true;
                    });
                  } else if (await isConnected()) {
                    // TODO : uncomment it after testing
                    // userData.put(UserData.username, usernameController.text);
                    // userData.put(UserData.phone, phoneController.text);

                    Map<String, dynamic> body = {
                      "username": usernameController.text,
                      "password": passwordController.text,
                      "phone": phoneController.text,
                      "longitude": location['longitude'],
                      "latitude": location['latitude'],
                      "address": location['address'],
                    };
                    http.Response res = await post('/session', body);
                    if (res.statusCode == 201) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'login');
                    } else if (res.statusCode == 409) {
                      oneButtonDialog(
                          context: context,
                          text:
                              "User with name '${usernameController.text}' already exists, try different name",
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
                  } else {
                    oneButtonDialog(
                        context: context,
                        text: 'Please connect to Internet',
                        onPressed: () {
                          Navigator.of(context).pop();
                        });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                      text: "Have an account?",
                      style: TextStyle(
                          color: Color.fromRGBO(128, 128, 128, 1),
                          fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  Log In',
                            style: TextStyle(color: primaryColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                                // navigate to desired screen
                              })
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
