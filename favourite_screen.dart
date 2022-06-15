import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/Common.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/ui_helper.dart';
import 'package:lottie/lottie.dart';

import '../widgets/text_style.dart';


class FavouriteScreen extends StatefulWidget {

  @override
  _FavouriteScreen createState() => _FavouriteScreen();

}

class _FavouriteScreen extends State<FavouriteScreen> {


  List<RewardsList> myRewardsList = [
    new RewardsList('assets/images/fish_curry.png','Fish Curry','1'),
    new RewardsList('assets/images/chicken_biryani.png','Chicken Biryani','2'),
    new RewardsList('assets/images/chow_mein.png','Chow Mein','2'),
    new RewardsList('assets/images/chicken_pokoda.png','Chicken Pokoda','1'),
    new RewardsList('assets/images/plain_rice.png','Plain Rice','3'),
    new RewardsList('assets/images/mushroom_fried_rice.png','Mushroom Fried Rice','2'),
    new RewardsList('assets/images/panner_tika.png','Panner Tika','1'),


  ];

  final Stream<QuerySnapshot> productStream =
  FirebaseFirestore.instance.collection('favourite_products').snapshots();
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('favourite_products');
  List  data = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getData() async {


    FirebaseFirestore.instance
        .collection('favourite_products')
        .doc(_auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data()['favorite_products'];
        setState(() {});

      } else {
        print('Document does not exist on the database');
      }
    });

    // print(allData);
  }
  deleteData(data1) async {
    var val = [];
    print(data1);

    Loader.show(context);


    try {
      await FirebaseFirestore.instance
          .collection('favourite_products')
          .doc(_auth.currentUser.uid)
          .update(
        {
          'favorite_products': FieldValue.arrayRemove([
            data1
          ])
        },
      ).whenComplete(() {
        getData();
        setState(() {});
        Loader.hide();
        showSuccessToast("Success");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        leadingWidth: 170,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text:  'Favourite Food',//My Cart
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              children: []),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,



        flexibleSpace: Container(
          decoration: BoxDecoration(
              color:UIHelper.STRAWBERRY_PRIMARY_COLOR,
            // color: Colors.white
            // gradient: new LinearGradient(
            //     colors: [
            //       Color(0xFFffffff),
            //       Color(0xFF009999)
            //     ],
            //     begin: const FractionalOffset(0.0, 0.0),
            //     end: const FractionalOffset(1.0, 1.0),
            //     stops: [0.0, 1.0],
            //     tileMode: TileMode.clamp),
          ),
        ),
        elevation: 0,
        actions: <Widget>[


          SizedBox(width: 20,),
        ],
      ),

      body: data.isEmpty?            Center(
        child:   Container(
          height: 300,
          width: 300,
          child: Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_atxkdesj.json'),
        ),
      )
          :
      Container(
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context,index){

              return Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                child: Card(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            // topRight: Radius.circular(5.0),
                            // bottomRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                          color: Colors.primaries[
                          Random().nextInt(Colors.primaries.length)],

                          // color:myRewardsList[index].position=='1'?Colors.red[300]:
                          // myRewardsList[index].position=='2'?Colors.orange[300]:
                          // myRewardsList[index].position=='3'?Colors.green[300]:
                          // myRewardsList[index].position=='ALERT DISPOSE!'?Colors.red[300]:Colors.grey[300],
                          // border: Border.all(color: Colors.black12),
                        ),
                        child: Center(
                            child: Center(
                                child: RotatedBox(
                                    quarterTurns: -3,
                                    child: Text(
                                      data[index]["store_name"],
                                      style: Style.white_16,
                                    )))),
                      ),
                      Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          // height: 20,
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                              onTap: () {
                                deleteData({
                                  "product_price":
                                  data[
                                  index]['product_price'],
                                  "store_name":
                                  data[
                                  index]['store_name'],
                                  "image_url":
                                  data[
                                  index]['image_url'],
                                  "product_name":
                                  data[
                                  index]['product_name'],
                                  "pid":
                                  data[
                                  index]['pid'],
                                  "category":
                                  data[
                                  index]['category'],

                                 "product_description": data[index]['product_description']


                                });

                              },
                              child: Image.asset(
                                "assets/images/grey_user_heart.png",
                                width: 20,
                                height: 20,color: Colors.red,)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 1,
                            width:
                            MediaQuery.of(context).size.width * 0.8,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: 20,
                                ),

                                // SizedBox(width: 25,),
                                ClipOval(
                                  child: SizedBox.fromSize(
                                      size: Size.fromRadius(
                                          30), // Image radius
                                      child: Image.network(
                                        data[index]['image_url'],
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 10.0),
                                  child: Column(
                                    children: [
                                      Column(children: [
                                        // SizedBox(height: 20,),

                                        Container(
                                            width: 200,
                                            child: Text(
                                              data[index]['product_name'],
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            width: 200,
                                            child: Text(
                                              " \$ ${data[index]['product_price']}",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            width: 200,
                                            child: Text(
                                              " ${data[index]['product_description']}",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ))
                                      ]),
                                    ],
                                  ),
                                ),
                              ]),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     _user,
                              //     _admin,
                              //   ],
                              // ),
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              );


            }),
      )


    );
  }
}

class RewardsList{
  String image;
  String Name;
  String position;
  RewardsList(this.image,this.Name,this.position);
}










