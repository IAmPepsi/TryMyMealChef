import 'package:cloud_firestore/cloud_firestore.dart';

class Items
{
  String? mealID;
  String? itemID;
  String? itemInfo;
  String? itemTitle;
  String? longDescription;
  String? price;
  Timestamp? publishedDate;
  String? chefName;
  String? chefUID;
  String? status;
  String? thumbnailUrl;

  Items({
    this.mealID,
    this.itemID,
    this.itemInfo,
    this.itemTitle,
    this.longDescription,
    this.price,
    this.publishedDate,
    this.chefName,
    this.chefUID,
    this.status,
    this.thumbnailUrl,
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    mealID = json["mealID"];
    itemID = json["itemID"];
    itemInfo = json["itemInfo"];
    itemTitle = json["itemTitle"];
    longDescription = json["longDescription"];
    price = json["price"];
    publishedDate = json["publishedDate"];
    chefName = json["chefName"];
    chefUID = json["chefUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}