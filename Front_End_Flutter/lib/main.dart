import 'package:flutter/material.dart';
import 'package:helpingworld/screens/login_screen.dart';
import 'package:helpingworld/screens/mapview.dart';
import 'package:helpingworld/screens/profile_screen.dart';
import 'package:helpingworld/screens/signup_screen.dart';
import 'package:helpingworld/screens/posts_screen.dart';
import 'package:helpingworld/screens/post_screen.dart';
import 'package:helpingworld/user_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box userData;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  userData = await Hive.openBox('userData');
  // userData.put('t', 'Three');
  // userData.put('f', 'five');
  // userData.put('fo', 'Four');
  // print(userData.values);
  // print(userData.values.runtimeType);
  // userData.delete(5);
  // var a = userData.values.map((e) => 'Mapped ' + e).toList();
  // print(a);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          'login': (context) => LoginScreen(),
          'profile': (context) => ProfileScreen(),
          'post': (context) => PostScreen(),
          'posts': (context) => PostsScreen()
        },
        theme: ThemeData(
          primaryColor: Color.fromRGBO(86, 78, 183, 1),
          scaffoldBackgroundColor: Color.fromRGBO(242, 242, 242, 1),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Helping World',
        home: Material(
          child: (userData.get(UserData.isLoggedIn) ?? false)
              ? PostsScreen()
              : LoginScreen(),
        ));
  }
}
