import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_my_meal_chef/mealsScreens/home_screen.dart';
import 'package:try_my_meal_chef/earningsScreen/earnings_screen.dart';
import 'package:try_my_meal_chef/historyScreen/history_screen.dart';
import 'package:try_my_meal_chef/ordersScreens/orders_screen.dart';
import 'package:try_my_meal_chef/shiftedParcelsScreen/shifted_parcels_screen.dart';

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';


class MyDrawer extends StatefulWidget
{
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}



class _MyDrawerState extends State<MyDrawer>
{
  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [

          //header
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      sharedPreferences!.getString("photoUrl")!,
                    ),
                  ),
                ),

                const SizedBox(height: 12,),

                //user name
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12,),

              ],
            ),
          ),

          //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //home
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.grey,),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //earnings
                ListTile(
                  leading: const Icon(Icons.euro_outlined, color: Colors.grey,),
                  title: const Text(
                    "Verdienste",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //my orders
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.grey,),
                  title: const Text(
                    "Neue Bestellungen",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> OrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //Shifted Parcels
                ListTile(
                  leading: const Icon(Icons.motorcycle, color: Colors.grey,),
                  title: const Text(
                    "Gesendete Bestellungen",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> ShiftedParcelsScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //history
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.grey,),
                  title: const Text(
                    "Bestellverlauf",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //logout
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.grey,),
                  title: const Text(
                    "Abmelden",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
