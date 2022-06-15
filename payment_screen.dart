import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:food_delivery/components/colors.dart';
import 'package:lottie/lottie.dart';

import '../new_tab_controller/tabs_screen.dart';
import '../widgets/ui_helper.dart';

class CreditCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreditCardPageState();
  }
}

class CreditCardPageState extends State<CreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: UIHelper.STRAWBERRY_PRIMARY_COLOR,

        automaticallyImplyLeading: true,
        title: Text('Payment'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardBgColor:          UIHelper.STRAWBERRY_PRIMARY_COLOR,

              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      themeColor:   UIHelper.STRAWBERRY_PRIMARY_COLOR ,

                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',

                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder Name',
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Procced',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      color: const Color(0xff1b447b),
                      onPressed: () async{
_displayDialog(context);
                        }


                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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


  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}