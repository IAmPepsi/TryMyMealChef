import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:try_my_meal_chef/mealsScreens/meals_ui_design_widget.dart';
import 'package:try_my_meal_chef/mealsScreens/upload_meals_screen.dart';
import 'package:try_my_meal_chef/global/global.dart';
import 'package:try_my_meal_chef/models/meals.dart';
import 'package:try_my_meal_chef/widgets/text_delegate_header_widget.dart';

import '../widgets/my_drawer.dart';


class HomeScreen extends StatefulWidget
{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
{
  getChefEarningsFromDatabase()
  {
    FirebaseFirestore.instance
        .collection("chefs")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((dataSnapShot)
    {
      previousEarning = dataSnapShot.data()!["earnings"].toString();
    });
  }

  @override
  void initState()
  {
    super.initState();

    getChefEarningsFromDatabase();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors:
                [
                  Colors.pinkAccent,
                  Colors.purpleAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadMealsScreen()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(title: "My Meals"),
          ),

          //1. write query
          //2  model
          //3. ui design widget

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chefs")
                .doc(sharedPreferences!.getString("uid"))
                .collection("meals")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot)
            {
              if(dataSnapshot.hasData) //if meals exists
                  {
                //display meals
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    Meals mealsModel = Meals.fromJson(
                      dataSnapshot.data.docs[index].data() as Map<String, dynamic>,
                    );

                    return MealsUiDesignWidget(
                      model: mealsModel,
                      context: context,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              }
              else //if meals NOT exists
                  {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No meals exists",
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
