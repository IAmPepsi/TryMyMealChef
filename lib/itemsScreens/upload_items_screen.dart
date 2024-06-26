import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try_my_meal_chef/mealsScreens/home_screen.dart';
import 'package:try_my_meal_chef/global/global.dart';
import 'package:try_my_meal_chef/models/meals.dart';
import 'package:try_my_meal_chef/splashScreen/my_splash_screen.dart';
import 'package:try_my_meal_chef/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


class UploadItemsScreen extends StatefulWidget
{
  Meals? model;

  UploadItemsScreen({this.model,});

  @override
  State<UploadItemsScreen> createState() => _UploadItemsScreenState();
}




class _UploadItemsScreenState extends State<UploadItemsScreen>
{
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController itemInfoTextEditingController = TextEditingController();
  TextEditingController itemTitleTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController = TextEditingController();

  bool uploading = false;
  String downloadUrlImage = "";
  String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveMealInfo()
  {
    FirebaseFirestore.instance
        .collection("chefs")
        .doc(sharedPreferences!.getString("uid"))
        .collection("meals")
        .doc(widget.model!.mealID)
        .collection("items")
        .doc(itemUniqueId)
        .set(
        {
          "itemID": itemUniqueId,
          "mealID": widget.model!.mealID.toString(),
          "chefUID": sharedPreferences!.getString("uid"),
          "chefName": sharedPreferences!.getString("name"),
          "itemInfo": itemInfoTextEditingController.text.trim(),
          "itemTitle": itemTitleTextEditingController.text.trim(),
          "longDescription": itemDescriptionTextEditingController.text.trim(),
          "price": itemPriceTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrlImage,
        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemUniqueId)
          .set(
          {
            "itemID": itemUniqueId,
            "mealID": widget.model!.mealID.toString(),
            "chefUID": sharedPreferences!.getString("uid"),
            "chefName": sharedPreferences!.getString("name"),
            "itemInfo": itemInfoTextEditingController.text.trim(),
            "itemTitle": itemTitleTextEditingController.text.trim(),
            "longDescription": itemDescriptionTextEditingController.text.trim(),
            "price": itemPriceTextEditingController.text.trim(),
            "publishedDate": DateTime.now(),
            "status": "available",
            "thumbnailUrl": downloadUrlImage,
          });
    });

    setState(() {
      uploading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
  }

  validateUploadForm() async
  {
    if(imgXFile != null)
    {
      if(itemInfoTextEditingController.text.isNotEmpty
          && itemTitleTextEditingController.text.isNotEmpty
          && itemDescriptionTextEditingController.text.isNotEmpty
          && itemPriceTextEditingController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //1. upload image to storage - get downloadUrl
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("chefsItemsImages").child(fileName);

        fStorage.UploadTask uploadImageTask = storageRef.putFile(File(imgXFile!.path));

        fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((urlImage)
        {
          downloadUrlImage = urlImage;
        });

        //2. save meal info to firestore database
        saveMealInfo();
      }
      else
      {
        Fluttertoast.showToast(msg: "Bitte füllen Sie das Formular vollständig aus.");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Bitte Bild auswählen.");
    }
  }

  uploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: ()
              {
                //validate upload form
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(
                Icons.cloud_upload,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
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
        ),
        title: const Text(
            "Neuen Artikel hochladen"
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          uploading == true
              ? linearProgressBar()
              : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          imgXFile!.path,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.cyanAccent,
            thickness: 1,
          ),

          //meal info
          ListTile(
            leading: const Icon(
              Icons.fastfood,
              color: Colors.indigo,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Artikelinfo",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyanAccent,
            thickness: 1,
          ),

          //meal title
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.indigo,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemTitleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Artikel Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyanAccent,
            thickness: 1,
          ),

          //item description
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.indigo,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemDescriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Artikelbeschreibung",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyanAccent,
            thickness: 1,
          ),

          //item price
          ListTile(
            leading: const Icon(
              Icons.euro,
              color: Colors.indigo,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemPriceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Artikelpreis",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyanAccent,
            thickness: 1,
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
            "Neues Artikel hinzufügen"
        ),
        centerTitle: true,
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white,
                size: 200,
              ),

              ElevatedButton(
                  onPressed: ()
                  {
                    obtainImageDialogBox();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Neues Artikel hinzufügen",
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  obtainImageDialogBox()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            title: const Text(
              "Meal Bild",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImagewithPhoneCamera();
                },
                child: const Text(
                  "Bild mit Kamera aufnehmen",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  getImageFromGallery();
                },
                child: const Text(
                  "Bild aus der Galerie auswählen",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {

                },
                child: const Text(
                  "Schließen",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  getImageFromGallery() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  captureImagewithPhoneCamera() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgXFile;
    });
  }
}
