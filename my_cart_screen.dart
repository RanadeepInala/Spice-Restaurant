import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/Common.dart';
import 'package:food_delivery/components/colors.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/text_style.dart';
import 'package:food_delivery/widgets/ui_helper.dart';
import 'package:lottie/lottie.dart';

import '../check_out/check_out_screen.dart';

class MyCartScreenScreen extends StatefulWidget {
  @override
  _MyCartScreenScreen createState() => _MyCartScreenScreen();
}

class _MyCartScreenScreen extends State<MyCartScreenScreen> {
  List<RewardsList> myRewardsList = [
    new RewardsList('assets/images/fish_curry.png', 'Fish Curry', '1', '1',
        '₹ 80', 'Malva Restaurant', '1'),
    new RewardsList('assets/images/chicken_biryani.png', 'Chicken Biryani', '2',
        '0', '₹ 200', 'Chancellor Restaurant', '5'),
    new RewardsList('assets/images/chow_mein.png', 'Chow Mein', '2', '0',
        '₹ 60', 'Venus Inn Restaurant', '3'),
    new RewardsList('assets/images/chicken_pokoda.png', 'Chicken Pokoda', '1',
        '1', '₹ 120', 'Nakli Dhaba', '2'),
    new RewardsList('assets/images/plain_rice.png', 'Plain Rice', '3', '0',
        '₹ 40', 'Adda Unplugged', '1'),
    new RewardsList('assets/images/mushroom_fried_rice.png',
        'Mushroom Fried Rice', '2', '0', '₹ 100', 'Barbeque Nation', '2'),
    new RewardsList('assets/images/panner_tika.png', 'Panner Tika', '1', '0',
        '₹ 160', 'Michael Kitchen', '10'),
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  List data = [];

  Future<void> getData() async {
    // Get docs from collection reference
    // QuerySnapshot querySnapshot = await _collectionRef.get();
    //
    // // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    FirebaseFirestore.instance
        .collection('Cart')
        .doc(_auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // for(int i =0;i >=documentSnapshot.data()['favorite_products'].lenghth i++)
        data = documentSnapshot.data()['items'];
        // print(
        //     'Document data: ${documentSnapshot.data()['items'][0]["store_name"]}');
        getTotalSum();
        print(data);
        setState(() {});
      } else {
        print('Document does not exist on the database');
      }
    });

    // print(allData);
  }

  int sum = 0;

  void getTotalSum() {
    for (int i = 0; i < data.length; i++) {

      sum +=int.parse(data[i]["product_price"]);
      setState((){});
    }
    // getTotal();
  }

int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leadingWidth: 170,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.2,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text: 'My Cart', //My Cart
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
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: data.isEmpty
          ?

            Center(
                child:   Container(
                  height: 300,
                  width: 300,
                  child: Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_atxkdesj.json'),
                ),
          )
          : SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.width*8,
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemBuilder: (BuildContext, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: Card(
                              child: Row(
                                children: [
                                  // Container(
                                  //   width: 30,
                                  //   height: 160,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.only(
                                  //       // topRight: Radius.circular(5.0),
                                  //       // bottomRight: Radius.circular(5.0),
                                  //       topLeft:  Radius.circular(5.0),
                                  //       bottomLeft:  Radius.circular(5.0),
                                  //     ),
                                  //     color:myRewardsList[index].position=='1'?Colors.red[300]:
                                  //     myRewardsList[index].position=='2'?Colors.orange[300]:
                                  //     myRewardsList[index].position=='3'?Colors.green[300]:
                                  //     myRewardsList[index].position=='ALERT DISPOSE!'?Colors.red[300]:Colors.grey[300],
                                  //     border: Border.all(color: Colors.black12),
                                  //
                                  //   ),
                                  //   child: Center(child: Center(child: RotatedBox(
                                  //       quarterTurns: -3,
                                  //       child: Text(  myRewardsList[index].store,style: Style.white_16,)))),
                                  // ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: (){
                                              if(quantity > 1){

                                                setState((){quantity -= 1;});


                                              }
                                              else{
                                                showSuccessToast('Quantity should not be less than or equal to 0 ');
                                              }

                                            },
                                            child: Icon(Icons.remove)),
                                        Container(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.15,
                                            // height: 20,
                                            alignment: Alignment.bottomRight,
                                            child: Text('QTY : ' + quantity.toString())),
                                        SizedBox(width: 10,),
                                        InkWell(
                                            onTap: (){
                                              quantity++;
                                              setState((){});
                                            },
                                            child: Icon(Icons.add)),
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
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
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
                                              padding: const EdgeInsets.only(
                                                  bottom: 0.0),
                                              child: Column(
                                                children: [
                                                  Column(children: [
                                                    // SizedBox(height: 20,),

                                                    Container(
                                                        width: 200,
                                                        child: Text(
                                                          data[index]
                                                              ['product_name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Container(
                                                        width: 200,
                                                        child: Text(
                                                          " \$ ${data[index]['product_price']}",

                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                    Container(
                                                        width: 200,
                                                        child: Text(
                                                          data[index]['product_description'] ==null||data[index]['product_description'] ==""?"":     data[index]['product_description'] ,

                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Roboto',
                                                              fontSize: 16,
                                                              color:
                                                              Colors.black),
                                                        ))

                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // _user,

                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 10),
                                                child: MaterialButton(
                                                  height: 35,
                                                  minWidth: 50,

                                                  // minWidth: double.infinity,
                                                  color: Colors.red[400],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(10.0)),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: new Text(
                                                              "Delete Cart"),
                                                          content: Text(
                                                              "Are you sure you want to delete ?"),
                                                          actions: <Widget>[
                                                            new FlatButton(
                                                              child: new Text(
                                                                  "No"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            new FlatButton(
                                                              child: new Text(
                                                                  "Yes"),
                                                              onPressed: () {
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
                                                                  index]['category']  ,
                                                                  "product_description": data[index]['product_description']



                                                                });

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    'Delete',
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
                        },
                        itemCount: data.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(5),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                      ),
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Visibility(
        visible: data.isEmpty ? false : true,
        child: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Container(
                  height: 0.3,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Container(
                              child: Text.rich(
                                TextSpan(
                                  text: " Total     : \$ ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      //text: sum.toString(),
                                      text: (sum * quantity).toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckOutScreenScreen(
                                          Data: data,
                                          TotalValue: sum.toString(),
                                      qunatity: quantity,
                                        )));
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColors),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Center(
                                child: new Text(
                                  '  Place Order ',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  deleteData(data1) async {
    var val = [];
    print(data1);

    Loader.show(context);
    // FirebaseFirestore.instance
    //     .collection('Cart').doc(_auth.currentUser.uid).delete().whenComplete((){
    //   Loader.hide();
    //   showSuccessToast("Item deleted succesfully");
    //   data = [];
    //   setState((){});
    // });

    try {
      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(_auth.currentUser.uid)
          .update(
        {
          'items': FieldValue.arrayRemove([
            data1
          ])
        },
      ).whenComplete(() {
        getData();
        setState(() {});
        Loader.hide();
      });
    } catch (e) {
      print(e);
    }
  }

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
  String qty;

  RewardsList(this.image, this.Name, this.position, this.status, this.price,
      this.store, this.qty);
}
