import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RegisterPage();
  }
}

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cpController = TextEditingController();
  final Connectivity _connectivity = Connectivity();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    cpController.dispose();
    super.dispose();
  }

/*  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      //Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
  } */

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("please wait"),
          ],
        ),
      ),
    );
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      //_login();
      registerBtn();
    });
  }

  @override
  Widget build(BuildContext context) {

    final nameLbl = Text('Name', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final name = TextFormField(
      controller: nameController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailLbl = Text('E-mail', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final email = TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phoneLbl = Text('Phone with country code', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final phone = TextFormField(
      controller: phoneController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Example +1 408 222 2222',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordLbl = Text('Password', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final password = TextFormField(
      controller: passwordController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final cpLbl = Text('Confirm Password', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final cp = TextFormField(
      controller: cpController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade200,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          /*onPressed: () async {
            await registerBtn();
          },*/
          onPressed: () {
            _onLoading();
          },
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Submit', style: TextStyle(color: Colors.white,fontSize: 18.0),),
              Icon(Icons.check_circle, color: Colors.white,)
            ],
          ),
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Registration'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 5.0),
            nameLbl,
            SizedBox(height: 5.0,),
            name,
            SizedBox(height: 15.0,),
            phoneLbl,
            SizedBox(height: 5.0,),
            phone,
            SizedBox(height: 15.0,),
            emailLbl,
            SizedBox(height: 5.0,),
            email,
            SizedBox(height: 15.0),
            passwordLbl,
            SizedBox(height: 5.0),
            password,
            SizedBox(height: 15.0,),
            cpLbl,
            SizedBox(height: 5.0,),
            cp,
            SizedBox(height: 10.0,),
            submitButton,
          ],
        ),
      ),
    );
  }

  void _showDiaglog(String txt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Center(
            child: new Text("Alert"),
          ),
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

  void registerBtn() async {
    if(nameController.text == ''){
      _showDiaglog('blank name');
    }
    else if(phoneController.text == '') {
      _showDiaglog('blank phone number');
    }
    else if(emailController.text == '') {
      _showDiaglog('blank email');
    }
    else if(passwordController.text == '') {
      _showDiaglog('blank password');
    }
    else if(cpController.text == '') {
      _showDiaglog('blank confirm password');
    }
    else if(passwordController.text != cpController.text) {
      passwordController.text = "";
      cpController.text = "";
      _showDiaglog('password did not match');
    }
    else{
      String connectionStatus;
      try {
        connectionStatus = (await _connectivity.checkConnectivity()).toString();
        if(connectionStatus == "ConnectivityResult.wifi" || connectionStatus == "ConnectivityResult.mobile") {

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
          globals.userCarServiceId.clear();
          globals.userServiceId.clear();

          final QuerySnapshot numberOfUsers = await Firestore.instance.collection('user').getDocuments();
          var list = numberOfUsers.documents;
          print('length: ${list.length}');
          print('length + 1 ${list.length + 1}');

          Firestore.instance.runTransaction((Transaction transaction) async {
            CollectionReference reference =
            Firestore.instance.collection('user');
            await reference.add({"id": list.length + 1, "name": nameController.text, "email": emailController.text, "phone_number": phoneController.text,
              "password": passwordController.text,
              "carAdded": 0});
          });

          final QuerySnapshot numberOfUsers1 = await Firestore.instance.collection('user').getDocuments();
          final List<DocumentSnapshot> dcmnts =  numberOfUsers1.documents;

          globals.userDocumentId = dcmnts[dcmnts.length - 1].documentID;

          globals.userId = list.length + 1;
          globals.carAdded = 0;
          globals.userName = nameController.text;
          globals.userEmail = emailController.text;

          Navigator.pushReplacementNamed(context, "/welcome");

        }
        else{
          _showDiaglog('The Internet connection appears to be offline');
        }
      } on PlatformException catch (e) {
        print("Exception: ${e.toString()}");
        _showDiaglog('Failed to get connectivity.');
      }
    }
  }
}