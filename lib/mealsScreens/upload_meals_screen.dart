import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try_my_meal_chef/mealsScreens/home_screen.dart';
import 'package:try_my_meal_chef/global/global.dart';
import 'package:try_my_meal_chef/splashScreen/my_splash_screen.dart';
import 'package:try_my_meal_chef/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


class UploadMealsScreen extends StatefulWidget
{
  @override
  State<UploadMealsScreen> createState() => _UploadMealsScreenState();
}




class _UploadMealsScreenState extends State<UploadMealsScreen>
{
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController mealInfoTextEditingController = TextEditingController();
  TextEditingController mealTitleTextEditingController = TextEditingController();

  bool uploading = false;
  String downloadUrlImage = "";
  String mealUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveMealInfo()
  {
    FirebaseFirestore.instance
        .collection("chefs")
        .doc(sharedPreferences!.getString("uid"))
        .collection("meals")
        .doc(mealUniqueId)
        .set(
        {
          "mealID": mealUniqueId,
          "chefUID": sharedPreferences!.getString("uid"),
          "mealInfo": mealInfoTextEditingController.text.trim(),
          "mealTitle": mealTitleTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrlImage,
        });

    setState(() {
      uploading = false;
      mealUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
  }

  validateUploadForm() async
  {
    if(imgXFile != null)
    {
      if(mealInfoTextEditingController.text.isNotEmpty
          && mealTitleTextEditingController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //1. upload image to storage - get downloadUrl
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("chefsMealsImages").child(fileName);

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
        Fluttertoast.showToast(msg: "Please write meal info and meal title.");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Please choose image.");
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
            "Upload New meal"
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
            color: Colors.pinkAccent,
            thickness: 1,
          ),

          //meal info
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: mealInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "meal info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),

          //meal title
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: mealTitleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "meal title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
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
            "Add New Meal"
        ),
        centerTitle: true,
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 200,
              ),

              ElevatedButton(
                  onPressed: ()
                  {
                    obtainImageDialogBox();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add New Meal",
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
              "Meal Image",
              style: TextStyle(
                color: Colors.deepPurple,
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
                  "Capture image with Camera",
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
                  "Select image from Gallery",
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
                  "Cancel",
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
