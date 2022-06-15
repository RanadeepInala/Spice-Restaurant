import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:food_delivery/new_tab_controller/tabs_screen.dart';
import 'package:food_delivery/sign_in/sign_in_screen.dart';
import 'package:food_delivery/sign_up/sign_up_screen.dart';
import 'package:food_delivery/utils/toast.dart';
import 'package:food_delivery/widgets/forgetPassButton_widget.dart';
import 'package:food_delivery/widgets/ui_helper.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {

  int colorCode=0;
  bool ispassword = true;
  bool isConfirmrpassword = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();


  final _auth = FirebaseAuth.instance;

String tabName = "User";
  final _fireStore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIHelper.STRAWBERRY_PRIMARY_COLOR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              UIHelper.signUpLower,
              style: TextStyle(color: UIHelper.WHITE, fontSize: 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // _user,
                //
                // _admin,

              ],
            ),
            _userName,
            _userEmail,
            _userPhone,
            _passwordField,
            _passwordConfirmField,
            _loginButton
            // Row(
            //   children: [
            //     ,
            //     _loginAdminButton,
            //   ],
            // ),


          ],
        ),
      ),
    );
  }

  Widget get _userName => Padding(
    padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
    child: TextField(
      style: TextStyle(color: UIHelper.WHITE),
      textAlign: TextAlign.left,
      controller: _usernameController,
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
        hintText: UIHelper.username,
        contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        hintStyle:
        TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget get _userEmail => Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: TextField(
      style: TextStyle(color: UIHelper.WHITE),
      textAlign: TextAlign.left,
      controller: _emailController,
      obscureText: false,
      autocorrect: false,
      cursorColor: UIHelper.WHITE,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.email,
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
        hintText: 'Email',
        contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        hintStyle:
        TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget get _userPhone => Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: TextField(
      style: TextStyle(color: UIHelper.WHITE),
      textAlign: TextAlign.left,
      controller: _mobileNumberController,
      obscureText: false,
      autocorrect: false,
      cursorColor: UIHelper.WHITE,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.phone,
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
        hintText:'Mobile Number',
        contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        hintStyle:
        TextStyle(color: UIHelper.WHITE, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget get _passwordField => Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: TextField(
      style: TextStyle(color: UIHelper.WHITE),
      textAlign: TextAlign.left,
      controller: _passwordController,
      obscureText: ispassword,
      autocorrect: false,
      cursorColor: UIHelper.WHITE,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: (){
              ispassword= !ispassword;
              setState((){});
            },
            child: Icon(
             ispassword==false? Icons.remove_red_eye:Icons.visibility_off,
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

  Widget get _passwordConfirmField => Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: TextField(
      style: TextStyle(color: UIHelper.WHITE),
      textAlign: TextAlign.left,
      controller: _confirmPasswordController,
      obscureText: isConfirmrpassword,
      autocorrect: false,
      cursorColor: UIHelper.WHITE,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: (){
              isConfirmrpassword= !isConfirmrpassword;
              setState((){});
            },
            child: Icon(
              ispassword==false? Icons.remove_red_eye:Icons.visibility_off,
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
        hintText: 'Confirm Password',
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
      onPressed: ()async {

        if(tabName == "User"){
          try {
            if(_passwordController.text==_confirmPasswordController.text){




              final newUser = await _auth.createUserWithEmailAndPassword(
                  email: _emailController.text, password: _passwordController.text);

              if (newUser != null) {
                Loader.show(context);


                DocumentReference ref = _fireStore.collection('users').document(newUser.user.uid);
                return ref.setData(
                    {
                      'user_name': _usernameController.text,
                      'email': _emailController.text,
                      'mobile_number': _mobileNumberController.text,
                      'password': _passwordController.text,
                      'confirm_password':_confirmPasswordController.text,
                      'is_Admin':false,
                      'uid': newUser.user.uid
                    }


                ).whenComplete(() {
                  Loader.hide();
                  showSuccessToast("Registration Completed");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabsScreen()));
                });

                print("User Added");
              }

            }
            else{
              showSuccessToast("Password should match");
            }
          } catch (e) {
            showSuccessToast(e.toString());
            Loader.hide();
            print(e);
          }
        }
        else{
          try {
            final newUser = await _auth.createUserWithEmailAndPassword(
                email: _emailController.text, password: _passwordController.text);
            if (newUser != null) {
              DocumentReference ref = _fireStore.collection('users').document(newUser.user.uid);
              return ref.setData(
                  {
                    'user_name': _usernameController.text,
                    'email': _emailController.text,
                    'mobile_number': _mobileNumberController.text,
                    'password': _passwordController.text,
                    'confirm_password':_confirmPasswordController.text,
                    'is_Admin':true,
                    'uid': newUser.user.uid
                  }


              );

              print("Admin Added");
            }
          } catch (e) {
            print(e);
          }
        }

      },
      child: Text(
        'Sign up',
        style: TextStyle(
            fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );

  // Widget get _admin => Padding(
  //   padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
  //   child: MaterialButton(
  //     height: 40,
  //     // minWidth: double.infinity,
  //     color:colorCode==1? UIHelper.WHITE:Colors.grey,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(10.0)),
  //     onPressed: () {
  //       colorCode=1;
  //       tabName = "Admin";
  //
  //       setState(() {});
  //     },
  //     child: Text(
  //       'Admin',
  //       style: TextStyle(
  //           fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
  //     ),
  //   ),
  // );

  // Widget get _user => Padding(
  //   padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
  //   child: MaterialButton(
  //     height: 40,
  //     // minWidth: double.infinity,
  //     color: colorCode==0? UIHelper.WHITE:Colors.grey,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(10.0)),
  //     onPressed: () {
  //       colorCode=0;
  //       tabName = "User";
  //       setState(() {});
  //
  //     },
  //     child: Text(
  //       'User',
  //       style: TextStyle(
  //           fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
  //     ),
  //   ),
  // );


}