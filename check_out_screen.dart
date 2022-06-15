import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/check_out/add_address_screen.dart';
import 'package:food_delivery/check_out/payment_screen.dart';
import 'package:food_delivery/components/colors.dart';
import 'package:food_delivery/home/home_screen.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/text_style.dart';
import 'package:food_delivery/widgets/ui_helper.dart';
import 'package:lottie/lottie.dart';

import '../Common.dart';
import '../home/new_category_screen.dart';
import '../new_tab_controller/tabs_screen.dart';

class CheckOutScreenScreen extends StatefulWidget {
  final List Data;
  final String TotalValue;
  final int qunatity;
  CheckOutScreenScreen(
      {required this.Data, required this.TotalValue, required this.qunatity});

  @override
  _CheckOutScreenScreen createState() => _CheckOutScreenScreen();
}

class _CheckOutScreenScreen extends State<CheckOutScreenScreen> {
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

  String? _dropDownValue;
  int val = -1;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  List data = [];
  final _fireStore = FirebaseFirestore.instance;

  Future<void> getData() async {
    FirebaseFirestore.instance
        .collection('Adress')
        .doc(_auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data()['MyAdress'];
        // print('Document data: ${documentSnapshot.data()['favorite_products'][0]["store_name"]}');

        setState(() {});
      } else {
        print('Document does not exist on the database');
      }
    });

    // print(allData);
  }

  void placeOrder() async {
    // Loader.show(context);

    if (val == -1) {
      showSuccessToast("Please select an address");
    } else if (_dropDownValue == null) {
      showSuccessToast("Please Select option");
    } else {
      try {
        // Loader.show(context);

        DocumentReference ref =
            _fireStore.collection('Orders').doc(_auth.currentUser.uid);

        for (int i = 0; i < widget.Data.length; i++) {
          return ref.set({
            "MyOrders": FieldValue.arrayUnion([
              {
                'product_name': widget.Data[i]['product_name'],
                'product_price': widget.Data[i]["product_price"],
                'category': widget.Data[i]["category"],
                'image_url': widget.Data[i]['image_url'],
                'adress': data[i]["Adress"] +
                    " " +
                    data[i]["country"] +
                    " " +
                    data[i]["state"],
                'order_time': DateTime.now(),
                'pid': widget.Data[i]["pid"],
                'store_name': widget.Data[i]['store_name'],
                'delivery_type': _dropDownValue,
                'user_name': data[i]['first_name'] + " " + data[i]['last_name'],
                'user_mobile': data[i]["mobile_number"],
                "quantity": widget.qunatity
              }
            ])
          }, SetOptions(merge: true));
        }
        // Loader.hide();
        // FirebaseFirestore.instance
        //     .collection('Cart')
        //     .doc(_auth.currentUser.uid)
        //     .delete()
        //     .whenComplete(() {});

        // Loader.hide();

        _displayDialog(context);

        showSuccessToast("Order Placed");
      } catch (e) {
        Loader.hide();
        showSuccessToast(e.toString());
      }
    }

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => NewCategoryScreen(
    //         )));

    showSuccessToast("Order Placed");

    _displayDialog(context);
  }

  int checkDelivery = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leadingWidth: 170,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text: 'Address Detail', //My Cart
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
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.Data.length,
                itemBuilder: (Context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Card(
                      child: Row(
                        children: [
                          Column(children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                // height: 20,
                                alignment: Alignment.bottomRight,
                                child:
                                    Text('QTY : ' + widget.qunatity.toString())),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                          size:
                                              Size.fromRadius(30), // Image radius
                                          child: Image.network(
                                            widget.Data[index]['image_url'],
                                            width: 25,
                                            height: 25,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0),
                                      child: Column(
                                        children: [
                                          Column(children: [
                                            // SizedBox(height: 20,),

                                            Container(
                                                width: 200,
                                                child: Text(
                                                  widget.Data[index]
                                                      ['product_name'],
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
                                                  " \$ ${widget.Data[index]['product_price']}",

                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                )),

                                            Container(
                                                width: 200,
                                                child: Text(
                                                  widget.Data[index]['product_description'] ==null||widget.Data[index]['product_description'] ==""?"":     widget.Data[index]['product_description'] ,

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
                                      // _user,

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: MaterialButton(
                                          height: 35,
                                          minWidth: 50,

                                          // minWidth: double.infinity,
                                          color: Colors.red[400],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0)),
                                          onPressed: () {
                                            if (data.isEmpty) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TabsScreen()));
                                            } else {
                                              data.removeAt(index);
                                            }
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
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
                }),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          // contentPadding: EdgeInsets.all(10),
                          hintText: '',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final data = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddressScreen()));

                            if (data != null) {
                              getData();
                            }

                            // CustomWidgets.alertDialog(context,'Are you sure you want to logout ?','Cancel','Confirm',logOut);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.red,
                                ),
                                color: Colors.red),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '  Add Address  ',
                                style: Style.white_16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            data.isEmpty
                ? Center(
                    child: Text("No Adress found"),
                  )
                : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),

              child: Column(
                children: [
                          // height: 640,

                           ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width * 0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: index,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = value.hashCode;
                                                    checkDelivery = 1;
                                                    setState(() {});
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, top: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,

                                              child: Text(
                                                'First Name',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              child: Text(
                                                data[index]['first_name'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'Last name',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['last_name'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'Mobile No',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['mobile_number'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'Email',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['email'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'ZipCode',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['zipcode'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'Country',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['country'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'State',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['state'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0, top: 0),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              width: 100,
                                              // alignment: Alignment.bottomCenter,

                                              child: Text(
                                                'Address',
                                                style: Style.black_16,
                                              ),
                                            ),
                                            Container(
                                                // height: 35,
                                                child: Text(':')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              // height: 35,
                                              // width: 200,
                                              // alignment: Alignment.bottomCenter,
                                              child: Text(
                                                data[index]['Adress'],
                                                maxLines: 1,
                                                style: Style.grey_700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: data.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                          ),
                ],
              ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height: 50,
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? Text(
                          'Select Delivery Option',
                          style: Style.black_16,
                        )
                      : Text(
                          _dropDownValue!,
                          style: TextStyle(color: Colors.blue),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                  items: ['Dine In', 'Carry Out', 'Delivery'].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: Style.black_16,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValue = val as String?;
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Container(
                        child: Text.rich(
                          TextSpan(
                            text: " Total     : \$ ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                text: widget.TotalValue,
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
                        onTap: () async {
                          if (_dropDownValue=="Delivery" && checkDelivery == 0) {
                            showSuccessToast("Please select an address");
                          } else if (_dropDownValue == null) {
                            showSuccessToast("Please Select Delivery option");
                          } else if(checkDelivery == 1 || _dropDownValue == "Dine In" || _dropDownValue == "Carry Out"){
                            // _displayDialog(context);


                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreditCardPage(
                                    )));

                            DocumentReference ref =
                              _fireStore.collection('Orders').doc(
                                  _auth.currentUser.uid);

                              for (int i = 0; i < widget.Data.length; i++) {
                                return ref.set({
                                  "MyOrders": FieldValue.arrayUnion([
                                    {
                                      'product_name': widget
                                          .Data[i]['product_name'],
                                      'product_price': widget
                                          .Data[i]["product_price"],
                                      'category': widget.Data[i]["category"],
                                      'image_url': widget.Data[i]['image_url'],
                                      'adress': data[i]["Adress"] +
                                          " " +
                                          data[i]["country"] +
                                          " " +
                                          data[i]["state"],
                                      'order_time': DateTime.now(),
                                      'pid': widget.Data[i]["pid"],
                                      'store_name': widget
                                          .Data[i]['store_name'],
                                      'delivery_type': _dropDownValue,
                                      'user_name': data[i]['first_name'] + " " +
                                          data[i]['last_name'],
                                      'user_mobile': data[i]["mobile_number"],
                                      "quantity": widget.qunatity,
                                      "product_description":widget.Data[i]["product_description"]
                                    }
                                  ])
                                }, SetOptions(merge: true));
                              }






                              // showSuccessToast("Order Placed");

                          }




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
                                'Confirm Order',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Colors.white, fontFamily: 'Roboto'),
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
    );
  }

  // Widget get _delete => Padding(
  //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
  //       child: MaterialButton(
  //         height: 35,
  //         minWidth: 50,
  //
  //         // minWidth: double.infinity,
  //         color: Colors.red[400],
  //         shape: RoundedRectangleBorder(
  //             borderRadius: new BorderRadius.circular(10.0)),
  //         onPressed: () {
  //           data.removeAt(index);
  //           Navigator.pushReplacement(
  //               context, MaterialPageRoute(builder: (context) => TabsScreen()));
  //         },
  //         child: Text(
  //           'Delete',
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
  _displayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 2000),
      // transitionBuilder: (context, animation, secondaryAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: ScaleTransition(
      //       scale: animation,
      //       child: child,
      //     ),
      //   );
      // },
      pageBuilder: (context, animation, secondaryAnimation) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TabsScreen(
                  )));

          // Navigator.pop(context);
// Here you can write your code

          setState(() {
            // Here you can write your code for open new view
          });

        });
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            color: Colors.green,
            child: Column(
              children: [
                Lottie.network(
                    'https://assets6.lottiefiles.com/packages/lf20_zxfettpd.json'),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: Lottie.network(
                          'https://assets5.lottiefiles.com/packages/lf20_vndgzois.json',
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text("Order Placed Succesfully",style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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
