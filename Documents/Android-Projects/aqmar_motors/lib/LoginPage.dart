import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;


class login extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new LoginPage(title: "Hello world title",);
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

 /* FlutterTts flutterTts = new FlutterTts();

  Future _speak() async{
    var result = await flutterTts.speak("Hello World");
    if (result == 1) setState(() => ttsState = flutterTts.);
  }

  Future _stop() async{
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }
*/
  @override
  void initState() {
    super.initState();
    initConnectivity();
    print("Title: ${widget.title}");
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  Future<Null> initConnectivity() async {
    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  /*void _select(Choice choice) {
    if (choice.title == "View Vehicle Details") {
      t  = "Details";
      print("vehicle details");
    Navigator.push(context, VehicleDetails());
    }
    if (choice.title == "Settings") {
      t  = "Application Settings";
      print("settings");
      Navigator.push(context, Settings());
    }
    if (choice.title == "Import/Export Center") {
      t  = "Import/Export Center";
      print("import/export center");
    Navigator.push(context, IECenter());
    }
    if (choice.title == "Contact Support..") {
      t = "Contact Support";
      print("contact support");
    Navigator.push(context, ContactSupport());
    }
    if (choice.title == "About") {
      t = "About Aqmar Motors";
      print("about");
    Navigator.push(context, About());
    }
  }*/

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      ),
    );
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      //_login();
      loginBtn();
    });
  }



  void _showDiaglog(String txt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Center(
            child: new Text("Alert"),
          ),
          /*content: new Center(
              child: new Text("Incorrect or blank email"),
            ),*/
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : <Widget>[
              Expanded(
                child: Text(
                  txt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,

                  ),
                ),
              )
            ],
          ),

          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loginBtn() async {
    if(emailController.text == "") {
      _showDiaglog('blank email');
    }
    else if(passwordController.text == ""){
      _showDiaglog('blank password');
    }
    else {
      print('email: ${emailController.text}');
      print('password: ${passwordController.text}');
      globals.userCarDocumentId.clear();
      globals.vehicleName.clear();
      globals.vehicleYear.clear();
      globals.vehicleNote.clear();
      globals.vehicleTransmission.clear();
      globals.vehicleTC.clear();
      globals.vehicleTS.clear();
      globals.vehicleTP.clear();
      globals.vehicleSubModel.clear();
      globals.vehicleModel.clear();
      globals.vehicleType.clear();
      globals.vehicleMake.clear();
      globals.vehicleLP.clear();
      globals.vehicleIP.clear();
      globals.vehicleFU.clear();
      globals.vehicleFT.clear();
      globals.vehicleEngine.clear();
      globals.vehicleCountry.clear();
      globals.vehicleDU.clear();


/*      final QuerySnapshot numberOfUsers = await Firestore.instance.collection('user').getDocuments();
      var list = numberOfUsers.documents;
      print('length: ${list.length}');




      print('List: ${list[0]['email']}');*/

      final QuerySnapshot emailResult = await Firestore.instance
          .collection('user')
          .where('email', isEqualTo: emailController.text)
          .limit(1)
          .getDocuments();

      final List<DocumentSnapshot> documents = emailResult.documents;

      if (documents.length == 1) {
        print('password: ${documents[0]['password']}');
        if (documents[0]['password'] == passwordController.text) {
          print('password match');
          emailController.text = "";
          passwordController.text = "";
          globals.isLoggedIn = true;
          globals.userEmail = documents[0]['email'];
          globals.userName = documents[0]['name'];
          globals.userId = documents[0]['id'];
          globals.userDocumentId = documents[0].documentID;
          globals.carAdded = 0;
          //globals.carAdded = documents[0]['carAdded'];


          final QuerySnapshot vehResult = await Firestore.instance
              .collection('vehicle')
              .where('user_id', isEqualTo: globals.userId)
              .limit(5)
              .getDocuments();
          final List<DocumentSnapshot> docmnts = vehResult.documents;

          for (var i = 0; i < docmnts.length; i++) {
            globals.userCarDocumentId.add(docmnts[i].documentID);
            print("user car document id: ${globals.userCarDocumentId[i]}");
            globals.vehicleName.add(docmnts[i]['name']);
            globals.vehicleYear.add(docmnts[i]['year']);
            globals.vehicleNote.add(docmnts[i]['vehicle_note']);
            globals.vehicleTransmission.add(docmnts[i]['transmission']);
            globals.vehicleTC.add(docmnts[i]['track_city']);
            globals.vehicleTS.add(docmnts[i]['tire_size']);
            globals.vehicleTP.add(docmnts[i]['tire_pressure']);
            globals.vehicleSubModel.add(docmnts[i]['sub_model']);
            globals.vehicleModel.add(docmnts[i]['model']);
            globals.vehicleType.add(docmnts[i]['type']);
            globals.vehicleMake.add(docmnts[i]['make']);
            globals.vehicleLP.add(docmnts[i]['license_plate']);
            globals.vehicleIP.add(docmnts[i]['insurance_policy']);
            globals.vehicleFU.add(docmnts[i]['fuel_unit']);
            globals.vehicleFT.add(docmnts[i]['fuel_tracking']);
            globals.vehicleEngine.add(docmnts[i]['engine']);
            globals.vehicleDU.add(docmnts[i]['distance_unit']);
            globals.vehicleCountry.add(docmnts[i]['country']);
            globals.carAdded += 1;
          }
          Navigator.pushReplacementNamed(context, "/welcome");
        }
        else{
          _showDiaglog('password not match');
        }
      }
      else {
        _showDiaglog('email not exists');
      }

      /*for(var i = 0; i <  list.length; i++) {
        if(list[i]['email'] == emailController.text) {
          if(list[i]['password'] == passwordController.text) {
            //emailController.text = "";
            //passwordController.text = "";
            Navigator.pushReplacementNamed(context, "/welcome");
          }
          else {
            //emailController.text = "";
            //passwordController.text = "";
            _showDiaglog('password not match');
          }
        }
      }*/
      //emailController.text = "";
      //passwordController.text = "";
      //_showDiaglog('email not exists');
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetsimage = new AssetImage('assets/logo.png');

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 125.0,
        child: Image(
          image: assetsimage,
        ),
      ),
    );

    final email = TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade200,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            //loginBtn();
            _onLoading();
            // Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Log In', style: TextStyle(color: Colors.white,fontSize: 18.0),),
              Icon(Icons.exit_to_app, color: Colors.white,)
            ],
          ),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      /*child: Text('${_connectionStatus}',
        style: TextStyle(color: Colors.black54,fontSize: 18.0),

      ),
      */
      child: Text('Forget Password', style: TextStyle(color: Colors.black,fontSize: 18.0),),
      onPressed: () {
        Navigator.pushNamed(context, "/forgetPassword");
      },
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade200,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            //new Page1();
            Navigator.pushNamed(context, "/register");

            // Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Register', style: TextStyle(color: Colors.white,fontSize: 18.0),),
              Icon(Icons.create, color: Colors.white,)
            ],
          ),
          //child: Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 10.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 10.0),
            loginButton,
            forgotLabel,
            SizedBox(height: 10.0,),
            registerButton
          ],
        ),
      ),
    );

    /*return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: false,
          padding: EdgeInsets.only(left: 24.0,right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 5.0,),
            email,
            SizedBox(height: 8.0,),
            password,
            SizedBox(height: 10.0,),
            loginBtn,
            SizedBox(height: 0.0,),
            forgetBtn,
            SizedBox(height: 0.0,),
            registerBtn
          ],
        ),
      ),
      /*appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text(widget.title),
        //title: new Image.asset('assets/302*480.jpg',fit: BoxFit.cover),
          centerTitle: true,
        //leading: new IconButton(icon: const Icon(Icons.line_weight), onPressed: () {}),
        /*actions: <Widget>[
          //new IconButton(icon: const Icon(Icons.), onPressed: () {}),
         new PopupMenuButton<Choice>(
             itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        //child: Text(choice.title),
                        //child: new IconButton(icon: Icon(choice.icon), onPressed: null),
                        child: Row(
                          children: <Widget>[
                            new IconButton(icon: Icon(choice.icon), onPressed: () {}, color: choice.color,),
                            Text(choice.title),
                          ],
                        ),
                      );
                }).toList();
          },
           onSelected: _select,
          ),
        ],*/
        */
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );*/
  }
}