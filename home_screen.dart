import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/Common.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/text_style.dart';
import 'package:food_delivery/widgets/ui_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../add_to_cart/my_cart_screen.dart';
import 'package:http/http.dart' as http;

import '../check_out/check_out_screen.dart';

class HomeScreen extends StatefulWidget {
  final String category;

  HomeScreen({required this.category});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<RewardsList> myRewardsList = [
    new RewardsList('assets/images/fish_curry.png', 'Fish Curry', '1', '1',
        '₹ 80', 'Malva Restaurant'),
    new RewardsList('assets/images/chicken_biryani.png', 'Chicken Biryani', '2',
        '0', '₹ 200', 'Chancellor Restaurant'),
    new RewardsList('assets/images/chow_mein.png', 'Chow Mein', '2', '0',
        '₹ 60', 'Venus Inn Restaurant'),
    new RewardsList('assets/images/chicken_pokoda.png', 'Chicken Pokoda', '1',
        '1', '₹ 120', 'Nakli Dhaba'),
    new RewardsList('assets/images/plain_rice.png', 'Plain Rice', '3', '0',
        '₹ 40', 'Adda Unplugged'),
    new RewardsList('assets/images/mushroom_fried_rice.png',
        'Mushroom Fried Rice', '2', '0', '₹ 100', 'Barbeque Nation'),
    new RewardsList('assets/images/panner_tika.png', 'Panner Tika', '1', '0',
        '₹ 160', 'Michael Kitchen'),
  ];
  late final Stream<QuerySnapshot> productStream;

  void retreive() {
    productStream = FirebaseFirestore.instance
        .collection('products')
        .where(
          'category',
          isEqualTo: widget.category,
        )
        .snapshots();

    print(widget.category);
  }

  void initState() {
    super.initState();
    getFavourite();
    retreive();
    setState(() {});
  }

  final _fireStore = FirebaseFirestore.instance;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('favourite_products');
  String pid = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> addToFavourites(
      pid, productname, productPrice, storename, imageurl, category,description) async{

    try {
      Loader.show(context);
      DocumentReference ref =
      _fireStore.collection('favourite_products').doc(_auth.currentUser.uid);
      return ref.set({
        "favorite_products": FieldValue.arrayUnion([
          {
            'pid': pid,
            "product_name": productname,
            "product_price": productPrice,
            "store_name": storename,
            "image_url": imageurl,
            "category": category,
            "product_description":description

          }
        ])
      }, SetOptions(merge: true)).whenComplete(() {
        showSuccessToast('Item favourited');
        Loader.hide();
      });
    } catch(e){
      Loader.hide();

      showSuccessToast(e.toString());
    }
  }

  Future<void> addToCart(
      pid, productname, productPrice, storename, imageurl, category,description) async{

    try {
      DocumentReference ref =
      _fireStore.collection('Cart').doc(_auth.currentUser.uid);

      showSuccessToast("Added to cart");

      return ref.set({
        "items": FieldValue.arrayUnion([
          {
            'pid': pid,
            "product_name": productname,
            "product_price": productPrice,
            "store_name": storename,
            "image_url": imageurl,
            "category": category,
            "product_description":description
          }
        ])
      }, SetOptions(merge: true));

    }
    catch(e){
      showSuccessToast(e.toString());
    }
  }


  SuperTooltip? tooltip;

  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (tooltip!.isOpen) {
      tooltip!.close();
      return false;
    }
    return true;
  }

  void onTap(data) {
    if (tooltip != null && tooltip!.isOpen) {
      tooltip!.close();
      return;
    }

    var renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox?;

    var targetGlobalCenter = renderBox
        .localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      arrowTipDistance: 1.0,
      arrowBaseWidth: 40.0,
      arrowLength: 40.0,
      borderColor: Colors.green,
      borderWidth: 5.0,
      snapsFarAwayVertically: true,
      showCloseButton: ShowCloseButton.inside,
      hasShadow: false,
      touchThrougArea: new Rect.fromLTWH(targetGlobalCenter.dx - 100,
          targetGlobalCenter.dy - 100, 200.0, 160.0),
      touchThroughAreaShape: ClipAreaShape.rectangle,
      content: new Material(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              data,
              softWrap: true,
            ),
          )),
    );

    tooltip!.show(context);
  }














  Future<void> shareProduct(String image, String name) async {
    final uri = Uri.parse(image);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: name);
  }

  String isLiked = "";
  List data = [];
  void getFavourite() async {
    FirebaseFirestore.instance
        .collection('favourite_products')
        .doc(CommonResources.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // for(int i =0;i >=documentSnapshot.data()['favorite_products'].lenghth i++)
        // data = documentSnapshot.data()['favorite_products'];
        // print('Document data: ${documentSnapshot.data()['favorite_products'][0]["store_name"]}');
        data = documentSnapshot.data()["favorite_products"];
        for (int i = 0; i > data.length; i++) {}
        setState(() {});
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  // void updateData( data1){
  //
  //   FirebaseFirestore.instance
  //       .collection('products')
  //       .where('product_name', isEqualTo: data1)
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((element) {
  //       FirebaseFirestore.instance
  //           .collection('products')
  //           .doc(element.id).get();
  //
  //
  //     });
  //   });
  // }

// String isFavoirite(){
//   var userData = FirebaseFirestore.instance.collection("favourite_products").document(CommonResources.uid).snapshots();
//   return userData["pid"];
//
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: UIHelper.STRAWBERRY_PRIMARY_COLOR,
        leadingWidth: 170,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text: 'Home', //My Cart
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
            color: UIHelper.STRAWBERRY_PRIMARY_COLOR,
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
          Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCartScreenScreen()));

                    setState(() {});
                  },
                  child: Image.asset(
                    'assets/images/my_cart_logo.png',
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ))),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
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
                                            data['store_name'],
                                            style: Style.white_16,
                                          )))),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [
                                  Container(
                                    // width:
                                        // MediaQuery.of(context).size.width * 0.1,
                                    // height: 20,
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        onTap: () {
                                          Loader.show(context);
                                          addToFavourites(
                                              data['pid'],
                                              data["product_name"],
                                              data['product_price'],
                                              data['store_name'],
                                              data['image_url'],
                                              data['category'],
                                              data['product_description']

                                          );

                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            getFavourite();
                                            Loader.hide();
                                          });
                                        },
                                        child: Image.asset(
                                          "assets/images/grey_user_heart.png",
                                          width: 20,
                                          height: 20,
                                          color: data['pid'] == pid
                                              ? Colors.red
                                              : Colors.grey,
                                        )),
                                  ),
                                  SizedBox(width: 20,),
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.4,
                                    // height: 20,
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        onTap: () {
                                          shareProduct(data['image_url'],
                                              data['product_name']);
                                        },
                                        child: Image.asset(
                                          "assets/images/share_link.png",
                                          width: 20,
                                          height: 20,
                                          color: data['pid'] == pid
                                              ? Colors.red
                                              : Colors.grey,
                                        )),
                                  ),
                          // We create the tooltip on the first use

                                ],
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
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                              data['image_url'],
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
                                                    data['product_name'],
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
                                                  " \$ ${data['product_price']}",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )),
                                              SizedBox(height: 10,),
                                              Container(
                                                  width: 200,
                                                  child: Text(
                                                    data['product_description'] ==null||data['product_description'] ==""?"":     data['product_description'] ,
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

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: MaterialButton(
                                            height: 40,
                                            minWidth: 100,
                                            // minWidth: double.infinity,
                                            color: Colors.blue[400],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            onPressed: () {
                                              addToCart(
                                                  data['pid'],
                                                  data["product_name"],
                                                  data['product_price'],
                                                  data['store_name'],
                                                  data['image_url'],
                                                  data['category'],
                                               data['product_description']
                                              );

                                              setState(() {});
                                            },
                                            child: Text(
                                              'Add To Cart',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: MaterialButton(
                                            height: 40,
                                            minWidth: 100,

                                            // minWidth: double.infinity,
                                            color: Colors.red[400],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckOutScreenScreen(
                                                            Data: [data],
                                                            TotalValue: data[
                                                                'product_price'],
                                                            qunatity: 1,

                                                          )));
                                              setState(() {});
                                            },
                                            child: Text(
                                              '   Buy Now   ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget get _admin =>
  //     Padding(
  //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
  //       child: MaterialButton(
  //         height: 40,
  //         minWidth: 100,
  //
  //         // minWidth: double.infinity,
  //         color: Colors.red[400],
  //         shape: RoundedRectangleBorder(
  //             borderRadius: new BorderRadius.circular(10.0)),
  //         onPressed: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => CheckOutScreenScreen(Data: data,TotalValue: data['product_price'],)));
  //           setState(() {});
  //         },
  //         child: Text(
  //           '   Buy Now   ',
  //           style: TextStyle(
  //               fontSize: 17,
  //               color: Colors.white,
  //               fontWeight: FontWeight.normal),
  //         ),
  //       ),
  //     );

  Widget get _user => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: MaterialButton(
          height: 40,
          minWidth: 100,
          // minWidth: double.infinity,
          color: Colors.blue[400],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            setState(() {});
          },
          child: Text(
            'Add To Cart',
            style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        ),
      );
}

class RewardsList {
  String image;
  String Name;
  String position;
  String status;
  String price;
  String store;

  RewardsList(this.image, this.Name, this.position, this.status, this.price,
      this.store);
}
