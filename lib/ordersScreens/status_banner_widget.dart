import 'package:flutter/material.dart';

import '../mealsScreens/home_screen.dart';


class StatusBanner extends StatelessWidget
{
  bool? status;
  String? orderStatus;

  StatusBanner({this.status, this.orderStatus,});



  @override
  Widget build(BuildContext context)
  {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:
            [
              Colors.cyanAccent,
              Colors.lightBlue,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 30,),

          Text(
            orderStatus == "ended"
                ? "Bestellung geliefert $message"
                : orderStatus == "shifted"
                ? "Bestellung verschoben $message"
                : orderStatus == "normal"
                ? "Bestellung aufgegeben $message"
                : "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
              decorationStyle: TextDecorationStyle.solid,
              wordSpacing: 2.0,),
          ),

          const SizedBox(width: 6,),

          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
