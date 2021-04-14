import 'package:flutter/material.dart';
import 'package:helpingworld/constants.dart';
import 'package:helpingworld/main.dart';
import 'package:helpingworld/screens/history_screen.dart';
import 'package:helpingworld/utilities.dart';
import 'package:helpingworld/user_data.dart';
import 'package:helpingworld/widgets/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:helpingworld/network_helper.dart';

class ResponseScreen extends StatefulWidget {
  final List responses;
  final int id;
  ResponseScreen({@required this.responses, @required this.id});

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  List responses;
  @override
  void initState() {
    responses = widget.responses;
    print(responses);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response'),
      ),
      body: ListView.builder(
          itemCount: responses.length,
          itemBuilder: (context, index) {
            var r = responses[index];
            return Card(
              child: ListTile(
                onTap: () async {
                  if (await isConnected()) {
                    twoButtonDialog(
                        context: context,
                        text: 'Do you want  to accept this request ?',
                        onPressedYes: () async {
                          Map<String, dynamic> body = {
                            "post_id": widget.id,
                            "username": r["username"],
                          };
                          print(body);
                          http.Response res = await put('/taking', body);
                          if (res.statusCode == 200) {
                            print(res.statusCode);
                            print(res.body);
                            setState(() {
                              Navigator.pop(context);
                            });
                          } else {
                            oneButtonDialog(
                                context: context,
                                text: "Some error occurred, try again",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                          }
                        },
                        onPressedNo: () {
                          print('no pressed');
                          Navigator.pop(context);
                        });
                  } else {
                    oneButtonDialog(
                        context: context,
                        text: 'Please connect to Internet',
                        onPressed: () {
                          Navigator.of(context).pop();
                        });
                  }
                },
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r['username']),
                    Text(r['phone']),
                  ],
                ),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${r['address']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(getDate(r['created_at']))
                    ]),
              ),
            );
          }),
    );
  }
}
