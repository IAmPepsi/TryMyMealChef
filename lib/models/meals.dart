import 'package:cloud_firestore/cloud_firestore.dart';

class Meals
{
  String? mealID;
  String? mealInfo;
  String? mealTitle;
  Timestamp? publishedDate;
  String? chefUID;
  String? status;
  String? thumbnailUrl;

  Meals({
    this.mealID,
    this.mealInfo,
    this.mealTitle,
    this.publishedDate,
    this.chefUID,
    this.status,
    this.thumbnailUrl,
  });

  Meals.fromJson(Map<String, dynamic> json)
  {
    mealID = json["mealID"];
    mealInfo = json["mealInfo"];
    mealTitle = json["mealTitle"];
    publishedDate = json["publishedDate"];
    chefUID = json["chefUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}