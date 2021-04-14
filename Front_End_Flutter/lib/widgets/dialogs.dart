import 'package:flutter/material.dart';
import 'package:helpingworld/widgets/my_button.dart';

oneButtonDialog({context, text, onPressed}) async => await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ),
        content: MyButton(text: 'OK', onPressed: onPressed),
      );
    });

twoButtonDialog(
        {context, text, ybtntxt, nbtntxt, onPressedYes, onPressedNo}) async =>
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: TextStyle(fontSize: 16.0),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                  text: ybtntxt ?? 'Yes',
                  onPressed: onPressedYes,
                ),
                SizedBox(
                  width: 5.0,
                ),
                MyButton(
                  text: nbtntxt ?? 'No',
                  onPressed: onPressedNo,
                ),
              ],
            ),
          );
        });
