import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/utils/firebase_helper.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/text_style.dart';
import 'package:food_delivery/widgets/ui_helper.dart';


class AddAddressScreen extends StatefulWidget {

  @override
  _AddAddressScreen createState() => _AddAddressScreen();

}

class _AddAddressScreen extends State<AddAddressScreen> {

  final _fireStore = FirebaseFirestore.instance;


  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _createMobileNoController = new TextEditingController();
  TextEditingController _createZipCodeController = new TextEditingController();
  TextEditingController _createAddressController = new TextEditingController();
  TextEditingController _createStateController = new TextEditingController();
  TextEditingController _createCountryController = new TextEditingController();


  String? _dropDownValue;

  @override
  void initState() {
    super.initState();

    setState(() {});
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        // leadingWidth: 170,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text:  'Add Address',//My Cart
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


          SizedBox(width: 20,),
        ],
      ),
      body: Container(
        // height: MediaQuery.of(context).size.width*8,
        child: Column(

          children: [
            SizedBox(height: 20,),


            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _firstNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _lastNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _createMobileNoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Mobile NO',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _createZipCodeController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Zip Code',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _createCountryController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _createStateController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'State',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(style: Style.black_16,
                        controller: _createAddressController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 15, top: 5, right: 15),
                          fillColor: Colors.white,
                          // suffixText: 'Change',

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey,),
                    // color: Colors.red
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: _dropDownValue == null
                          ? Text('Select Delivery Type',style: Style.black_16,)
                          : Text(
                        _dropDownValue!,
                        style: TextStyle(color: Colors.black),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black,fontSize: 16),
                      items: ['Home', 'Office'].map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val,style: Style.black_16,),
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
              ),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _update,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _update => Padding(
    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
    child: MaterialButton(
      height: 40,
      minWidth: 100,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      onPressed: () async{
        DocumentReference ref = _fireStore.collection('Adress').doc(_auth.currentUser.uid);

showSuccessToast("Adress Added");
Navigator.pop(context,'1');
        return ref.set({
          "MyAdress": FieldValue.arrayUnion([
            {
              'first_name': _firstNameController.text,
              'last_name':_lastNameController.text,
              'email': _emailController.text,
              'mobile_number': _createMobileNoController.text,
              'Adress': _createAddressController.text,
              'country':_createCountryController.text,
              'state':_createStateController.text,
              'zipcode': _createZipCodeController.text,
              'delivery_type':_dropDownValue
            }
          ])
        }, SetOptions(merge: true));

      },
      child: Text(
        'Add',
        style: TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );

}











