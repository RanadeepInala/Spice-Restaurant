import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/admin/admin_home_screen.dart';
import 'package:food_delivery/admin/admin_product_tab.dart';
import 'package:food_delivery/sign_up/sign_up_screen.dart';
import 'package:food_delivery/tab_controller/bottom_tab_controller.dart';
import 'package:food_delivery/utils/firebase_helper.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/forgetPassButton_widget.dart';
import 'package:food_delivery/widgets/ui_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../Common.dart';
import '../components/colors.dart';
import '../new_tab_controller/tabs_screen.dart';
import '../widgets/text_style.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController forgot_email_controller = TextEditingController();
  TextEditingController forgot_password_controller = TextEditingController();

  final _auth = FirebaseAuth.instance;
  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIHelper.STRAWBERRY_PRIMARY_COLOR,
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  UIHelper.signInLower,
                  style: TextStyle(color: UIHelper.WHITE, fontSize: 40),
                ),
                _textField,
                _passwordField,
                new ForgetPasswordButton(
                  onTap: () async {
                    return showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              contentPadding: const EdgeInsets.all(0),
                              content: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  height: 250,
                                  width: 350,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 54.0,
                                          decoration: BoxDecoration(
                                              color: blue_blue,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              )),
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Email Verification ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        //Resource
                                                        color: Colors.white,
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       right: 15.0),
                                              //   child: InkWell(
                                              //     child: Align(
                                              //       alignment: Alignment.centerRight,
                                              //       child: Image.asset(
                                              //         "assets/images/cancel.png",
                                              //         width: 17,
                                              //         height: 17,
                                              //         color: Colors.white,
                                              //       ),
                                              //     ),
                                              //     onTap: () {
                                              //       // callBack(true,'name');
                                              //       Navigator.of(context).pop();
                                              //     },
                                              //   ),
                                              // ),
                                            ],
                                          ))),
                                      SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                style: Style.black_16,
                                                controller:
                                                    forgot_email_controller,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  labelText: 'Enter your email',
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                  // focusedBorder: InputBorder.none,
                                                  // enabledBorder: InputBorder.none,
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  // border: OutlineInputBorder(
                                                  //   borderRadius: BorderRadius.circular(8.0),
                                                  // ),
                                                  // focusedBorder: OutlineInputBorder(),
                                                  filled: true,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 15,
                                                          top: 5,
                                                          right: 15),
                                                  fillColor: Colors.white,
                                                  // suffixText: 'Change',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, top: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        color: Colors.red),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Cancel',
                                                          style: Style.white_16,
                                                        )
                                                        // Image.asset('assets/images/right_arrow_one.png',width: 30,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    updateData(
                                                        forgot_email_controller
                                                            .text,
                                                        forgot_password_controller
                                                            .text);
                                                    Navigator.of(context).pop();
                                                    forgot_email_controller
                                                        .clear();
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        color: kPrimaryColors),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Send',
                                                          style: Style.white_16,
                                                        )
                                                        // Image.asset('assets/images/right_arrow_one.png',width: 30,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                        });
                  },
                  color: UIHelper.WHITE,
                  rightPadding: 30,
                ),
                _loginButton,
                SizedBox(height: 30),

                InkWell(
                    onTap: () {
                      signup(context);
                    },
                    child: Image.asset(
                      "assets/images/Google.png",
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    )),
                SizedBox(height: 50),
                // Text(
                //   "Sign in with your email and password \n or  \n Continue with social media",
                //   textAlign: TextAlign.center,  style: TextStyle(fontSize: 16,color: Colors.white),
                // ),
                // SizedBox(height:50),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset("assets/images/facebook.png", width: 30, height: 30,),
                //     SizedBox(width: 30,),
                //     Image.asset("assets/images/search.png", width: 30, height: 30,),
                //
                //   ],
                // ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New User? ", //Don’t have an account?
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));

                              setState(() {});
                            },
                            child: Text(
                              "Sign Up ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          // Text(
                          //   "/", style: TextStyle(fontSize: getProportionateScreenWidth(16), color: kPrimaryColor),
                          // ),
                          // InkWell(
                          //   onTap:(){
                          //   },
                          //   child: Text(
                          //     " Sign In",
                          //     style: TextStyle(fontSize: getProportionateScreenWidth(16), color: kPrimaryColor),
                          //   ),
                          // ),
                        ],
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

  Future<void> signup(BuildContext context) async {
    Loader.show(context);
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);
      User user = result.user;

      if (result != null) {
        Loader.hide();

        print(user.uid);
        addData(user);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
        getdata();
      }

      // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  Future<void> addData(User user) {
    DocumentReference ref = _fireStore.collection('users').document(user.uid);
    return ref.setData({
      'user_name': user.displayName,
      'email': user.email,
      'mobile_number': user.email,
      'password': "",
      'confirm_password': "",
      'is_Admin': false,
      'uid': user.uid
    });
  }

  Widget get _textField => Padding(
        padding: const EdgeInsets.fromLTRB(50, 70, 50, 10),
        child: TextField(
          controller: _idController,
          style: TextStyle(color: UIHelper.WHITE),
          textAlign: TextAlign.left,
          obscureText: false,
          autocorrect: false,
          cursorColor: UIHelper.WHITE,
          maxLines: 1,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.person,
                color: UIHelper.WHITE,
              ),
            ),
            filled: true,
            fillColor: UIHelper.STRAWBERRY_SECONDARY_COLOR,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                    color: UIHelper.STRAWBERRY_SECONDARY_COLOR, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                    color: UIHelper.STRAWBERRY_SECONDARY_COLOR, width: 2)),
            hintText: UIHelper.email,
            contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            hintStyle:
                TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
          ),
        ),
      );
  bool isVisible = false;

  void updateData(data1, newValue) async {
    Loader.show(context);
    try {
      await _auth.sendPasswordResetEmail(email: data1).whenComplete(() {
        Loader.hide();
        showSuccessToast("Password reset link sen to your mail");
      });
    } on FirebaseAuthException catch (e) {
      Loader.hide();
      if (e.code == "user-not-found") {
        showSuccessToast("User not Registered");
      }
    }
  }

  Widget get _passwordField => Padding(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: TextField(
          controller: _passwordController,
          style: TextStyle(color: UIHelper.WHITE),
          textAlign: TextAlign.left,
          obscureText: isVisible,
          autocorrect: false,
          cursorColor: UIHelper.WHITE,
          maxLines: 1,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  isVisible = !isVisible;
                  setState(() {});
                },
                child: Icon(
                  isVisible == false
                      ? Icons.remove_red_eye
                      : Icons.visibility_off,
                  color: UIHelper.WHITE,
                ),
              ),
            ),
            filled: true,
            fillColor: UIHelper.STRAWBERRY_SECONDARY_COLOR,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                    color: UIHelper.STRAWBERRY_SECONDARY_COLOR, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                    color: UIHelper.STRAWBERRY_SECONDARY_COLOR, width: 2)),
            hintText: UIHelper.password,
            contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            hintStyle:
                TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget get _loginButton => Padding(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: MaterialButton(
          height: 56,
          minWidth: double.infinity,
          color: UIHelper.WHITE,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          onPressed: () async {
            Loader.show(context);

            try {
              final user = await _auth.signInWithEmailAndPassword(
                  email: _idController.text,
                  password: _passwordController.text);

              if (user != null) {
                getdata();

                Loader.hide();
              }
            } catch (e) {
              Loader.hide();
              showSuccessToast(e.toString());
              print(e.toString());
            }
          },
          child: Text(
            UIHelper.login,
            style: TextStyle(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );

  void getdata() async {
    User user = _auth.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      CommonResources.is_Admin = userData.data()["is_Admin"];
      CommonResources.uid = userData.data()["uid"];
      CommonResources.email = userData.data()["email"];
      CommonResources.mobile = userData.data()["mobile_number"];
      CommonResources.userName = userData.data()["user_name"];
      CommonResources.Password = userData.data()["password"];

      print(CommonResources.is_Admin);
      setState(() {});

      if (userData.data()["is_Admin"] == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TabsScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AppOwnerTicketsTabScreen()));
      }
    });
  }
}
