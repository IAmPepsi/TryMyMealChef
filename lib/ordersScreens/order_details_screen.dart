import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:try_my_meal_chef/ordersScreens/status_banner_widget.dart';
import '../models/address.dart';
import 'address_design_widget.dart';


class OrderDetailsScreen extends StatefulWidget
{
  String? orderID;

  OrderDetailsScreen({this.orderID,});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}



class _OrderDetailsScreenState extends State<OrderDetailsScreen>
{
  String orderStatus = "";

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, AsyncSnapshot dataSnapshot)
          {
            Map? orderDataMap;
            if(dataSnapshot.hasData)
            {
              orderDataMap = dataSnapshot.data.data() as Map<String, dynamic>;
              orderStatus = orderDataMap["status"].toString();

              return Column(
                children: [

                  StatusBanner(
                    status: orderDataMap["isSuccess"],
                    orderStatus: orderStatus,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "€ " + orderDataMap["totalAmount"].toString(),
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 2,
                          decorationStyle: TextDecorationStyle.solid,
                          wordSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order ID = " + orderDataMap["orderId"].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order at = " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDataMap["orderTime"]))),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const Divider(
                    thickness: 1,
                    color: Colors.cyanAccent,
                  ),

                  orderStatus != "ended"
                      ? Image.asset("images/packing.png")
                      : Image.asset("images/delivered.jpg"),

                  const Divider(
                    thickness: 1,
                    color: Colors.cyanAccent,
                  ),

                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(orderDataMap["orderBy"])
                        .collection("userAddress")
                        .doc(orderDataMap["addressID"])
                        .get(),
                    builder: (c, AsyncSnapshot snapshot)
                    {
                      if(snapshot.hasData)
                      {
                        return AddressDesign(
                          model: Address.fromJson(
                              snapshot.data.data() as Map<String, dynamic>
                          ),
                          orderStatus: orderStatus,
                          orderId: widget.orderID,
                          chefId: orderDataMap!["chefUID"],
                          orderByUser: orderDataMap["orderBy"],
                          totalAmount: orderDataMap["totalAmount"].toString(),
                        );
                      }
                      else
                      {
                        return const Center(
                          child: Text(
                            "Es sind keine Daten vorhanden.",
                          ),
                        );
                      }
                    },
                  ),

                ],
              );
            }
            else
            {
              return const Center(
                child: Text(
                  "Es sind keine Daten vorhanden.",
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
