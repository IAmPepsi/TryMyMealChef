import 'package:flutter/material.dart';
import 'package:try_my_meal_chef/models/meals.dart';

import '../itemsScreens/items_screen.dart';

class MealsUiDesignWidget extends StatefulWidget
{
  Meals? model;
  BuildContext? context;

  MealsUiDesignWidget({this.model, this.context,});

  @override
  State<MealsUiDesignWidget> createState() => _MealsUiDesignWidgetState();
}



class _MealsUiDesignWidgetState extends State<MealsUiDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(
          model: widget.model,
        )));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                Image.network(
                  widget.model!.thumbnailUrl.toString(),
                  height: 220,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 1,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.model!.mealTitle.toString(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 3,
                      ),
                    ),
                    IconButton(
                      onPressed: ()
                      {

                      },
                      icon: const Icon(
                        Icons.delete_sweep,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
