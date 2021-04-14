import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:helpingworld/screens/signup_screen.dart';
import 'package:helpingworld/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/network_helper.dart';
import 'package:helpingworld/main.dart';
import 'package:helpingworld/widgets/dialogs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
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
                  'Login',
                  style: TextStyle(
                      color: Color.fromRGBO(21, 18, 135, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignupScreen();
                    }));
                    print('Sign up tapped');
                  },
                  child: Opacity(
                    opacity: 0.3,
                    child: Text(
                      'Sign Up',
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
            Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 8, left: 16.0, right: 16.0),
              child: TextField(
                controller: usernameController,
                onSubmitted: (value) {
                  print(value);
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1), fontSize: 20),
                  hintText: 'Type username ...',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 5,
                ),
                FlatButton(
                  onPressed: () {
                    print('forgot password tapped');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(128, 128, 128, 1),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor,
                onPressed: () async {
                  if (await isConnected()) {
                    http.Response res = await get(
                        '/session?username=${usernameController.text}&password=${passwordController.text}');
                    if (res.statusCode == 200) {
                      userData.put(UserData.isLoggedIn, true);
                      // TODO : uncomment it after testing
                      // userData.put(UserData.username, usernameController.text);
                      print(res.statusCode);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'posts');
                    } else if (res.statusCode == 401) {
                      oneButtonDialog(
                          context: context,
                          text: 'Wrong Username or Password',
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
                    'Login',
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
                      text: "Don\'t have an account?",
                      style: TextStyle(
                          color: Color.fromRGBO(128, 128, 128, 1),
                          fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  Sign up',
                            style: TextStyle(color: primaryColor, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SignupScreen();
                                }));
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
