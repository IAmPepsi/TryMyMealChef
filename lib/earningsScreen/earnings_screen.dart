import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';


class EarningsScreen extends StatefulWidget
{
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}



class _EarningsScreenState extends State<EarningsScreen>
{
  String totalChefEarnings = "";

  readTotalEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("chefs")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        totalChefEarnings = snap.data()!["earnings"].toString();
      });
    });
  }

  @override
  void initState()
  {
    super.initState();

    readTotalEarnings();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "€ " + totalChefEarnings,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Gesamteinnahmen",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.indigo,
                  thickness: 1.5,
                ),
              ),

              const SizedBox(height: 40.0,),

              Card(
                color: Colors.white54,
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 140),
                child: ListTile(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>  MySplashScreen()));
                  },
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Colors.indigo,
                  ),
                  title: const Text(
                    "Zurück",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
