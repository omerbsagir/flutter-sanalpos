import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';


class CustomSnackbar {
  static void show(BuildContext context,String message, Color backgroundColor ) {
    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      duration: Duration(milliseconds: 750),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Trigger a vibration when the SnackBar is shown.
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.removeCurrentSnackBar();
    scaffold.showSnackBar(snackBar);

    if(backgroundColor == Colors.red || backgroundColor == Colors.orange ) {
      Vibration.vibrate(duration: 750);
    }
    else if(backgroundColor == Colors.greenAccent){
      Vibration.vibrate(duration: 2000);
    }

  }

}
