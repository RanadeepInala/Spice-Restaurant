import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/add_to_cart/my_cart_screen.dart';
import 'package:food_delivery/home/home_screen.dart';
import 'package:food_delivery/widgets/text_style.dart';
import 'package:food_delivery/widgets/ui_helper.dart';


class NewCategoryScreen extends StatefulWidget {

  @override
  _NewCategoryScreen createState() => _NewCategoryScreen();

}

class _NewCategoryScreen extends State<NewCategoryScreen> {


  List<RewardsList> myRewardsList = [
    new RewardsList('Dessert '),
    new RewardsList('Cold drink '),
    new RewardsList('Alcoholic '),
    new RewardsList('Panner '),
    new RewardsList('Chicken '),
    new RewardsList('Rice '),
  ];
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('categories').snapshots();
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: UIHelper.STRAWBERRY_PRIMARY_COLOR,
        // leadingWidth: 170,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.3,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: RichText(
          text: TextSpan(
              text:  'Home',//My Cart
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

          Center(child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreenScreen()));

                setState(() {});
              },
              child: Image.asset('assets/images/my_cart_logo.png',width: 25,height: 25,color: Colors.white,))),

          SizedBox(width: 30,),
        ],
      ),
      body: Container(
        // height: MediaQuery.of(context).size.width*8,
        child: Column(
          children: [


            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
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
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom: 5,left: 8),
                      child: Card(

                        child: Container(
                          // width: 100,
                          height: 50,
                          child: Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                    size: Size.fromRadius(20), // Image radius
                                    child:  Image.network(data["category_image"],width: 25,height: 25,fit: BoxFit.cover,)
                                ),
                              ),                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0,right: 8,top: 8,bottom: 8),
                                  child: Container(
                                    // width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Expanded(child: Text(data["item_category"]))),
                                ),
                              ),

                              // Expanded(child: Container(child: Center(child: Expanded(child: Text('   '+myRewardsList[index].category))))),
                              Center(child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(category: data["item_category"],)));

                                    setState(() {});
                                  },
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset('assets/images/rightarrow_small.png',width: 25,height: 25)))),

                              SizedBox(width: 20,)
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )


          ],
        ),
      ),

    );
  }

  Widget get _admin => Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    child: MaterialButton(
      height: 40,
      minWidth: 100,

      // minWidth: double.infinity,
      color:Colors.red[400],
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      onPressed: () {
        setState(() {});
      },
      child: Text(
        '   Buy Now   ',
        style: TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.normal),
      ),
    ),
  );

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
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.normal),
      ),
    ),
  );
}
class RewardsList{
  String category;
  RewardsList(this.category);
}










