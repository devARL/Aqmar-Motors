import 'package:flutter/material.dart';
/*
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
//import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/services.dart';
*/
import 'package:aqmar_motors/LoginPage.dart';
import 'package:aqmar_motors/RegisterPage.dart';
import 'package:aqmar_motors/WelcomePage.dart';
import 'package:aqmar_motors/FPPage.dart';
import 'package:aqmar_motors/AddVehiclePage.dart';
import 'package:aqmar_motors/settings.dart';
import 'package:aqmar_motors/reminders.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Aqmar Motors',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      //home: new LoginPage(title: 'Aqmar Motors'),
      home: new login(),
      routes: {
       /*"/login": (_) => MyApp(),
        "/welcome": (_) => new WP(),
        "/register": (_) => new RP(),
        "/forgetPassword": (_) => new FPP(),
        "/addVehicle": (_) => new AV(),
        "/vehicleDetail": (_) => new VehicleDetail(),
         */

       "/login": (_) => new login(),
        "/welcome": (_) => new Welcome(),
        "/register": (_) => new Register(),
        "/forgetPassword": (_) => new FPPage(),
        "/addVehicle": (_) => new AddVehicle(),
        "/settings": (_) => new settings(),
        "/reminders": (_) => reminders(),

      },
    );
  }
}

/*
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

  @override
  void initState() {
    super.initState();
    initConnectivity();
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
        if(documents[0]['password'] == passwordController.text) {
          print('password match');
          emailController.text = "";
          passwordController.text = "";
          Navigator.pushReplacementNamed(context, "/welcome");
        }
        else {
          passwordController.text = "";
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
            loginBtn();
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
*/

/*
class WP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WelcomePage();
  }
}
class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => new WelcomePageState();
}
class WelcomePageState extends State<WelcomePage> {
  var items = new List<String>();

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    items.add('1');
    items.add('2');
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() {
            if (result.toString() == "ConnectivityResult.wifi" || result.toString() == "ConnectivityResult.mobile") {
              _connectionStatus = "Your data has not been synced.";
            }
            else {
              _connectionStatus = "The Internet connection appears to be offline.";
            }
          }
          );
        });
  }


  @override
  void dispose() {
    try {
      _connectivitySubscription.cancel();
    } catch (exception, stackTrace) {
      print(exception.toString());
    } finally {
      super.dispose();
    }
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
      if (connectionStatus == "ConnectivityResult.wifi" || connectionStatus == "ConnectivityResult.mobile") {
        _connectionStatus = "Your data has not been synced.";
      }
      else {
        _connectionStatus = "The Internet connection appears to be offline.";
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
        }),
        centerTitle: true,
        title: new Text('Welcome'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add), onPressed: () {
            Navigator.pushNamed(context, "/addVehicle");
          }, tooltip: "Add New vehicle",),

        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              child: new Text('${_connectionStatus}', style: TextStyle(color: Colors.white,fontSize: 16.0),),
              alignment: Alignment(0.0,0.0),
            ),
            /*new Expanded(
              child: ListView.builder(
                itemCount: items.length == null ? 0 : items.length,
                itemBuilder: (context, index)
                      {
    return ListTile(
    title:
    Text('${items[index]}', style: TextStyle(color: Colors.black, fontSize: 16.0), ),
    onTap: () {
    print('${items[index]}');
    },
    );
    },
                    ),
                  ),*/

            new Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('user').snapshots(),
                builder: (context, snapshot){
                  if (!snapshot.hasData) return const Text('loading...');
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index)
                    {
                      return ListTile(
                        /*title:
                        Text('${items[index]}', style: TextStyle(color: Colors.black, fontSize: 16.0), ),*/
                        title: Text('${snapshot.data.documents[index]['name']}'),
                        /*onTap: () {
                          print('${items[index]}');
                        },*/
                      );
                    },
                  );
                },
              ),
            ),

                ],
              ),
            );

  }
}
*/

/*
class FPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ForgetPasswordPage();
  }
}
class ForgetPasswordPage extends StatefulWidget {
  @override
  ForgetPasswordPageState createState() => new ForgetPasswordPageState();
}
class ForgetPasswordPageState extends State<ForgetPasswordPage> {

  final emailController = TextEditingController();
  final phoneController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void sendByEmail() async {
    if(emailController.text == '') {
      _showDiaglog('Incorrect or blank email');
    }
    else {
      print('${emailController.text}');
      final QuerySnapshot emailResult = await Firestore.instance
          .collection('user')
          .where('email', isEqualTo: emailController.text)
          .limit(1)
          .getDocuments();
      final List<DocumentSnapshot> documents = emailResult.documents;

      if (documents.length == 1) {
        //final smtpServer = gmail(username, password);

        var options = new SmtpOptions()
          ..hostName = 'localhost'
          ..port = 25
          ..username = 'mooinnkhan@gmail.com'
          ..password = 'moinkhan12345';

        var transport = new SmtpTransport(options);

        // Create the envelope to send.
        var envelope = new Envelope()
          ..from = 'mooinnkhan@gmail.com'
          ..recipients = ['developeralirazalakhani@gmail.com', 'argalakhani@gmail.com']
          ..subject = 'Your subject'
          ..text = 'Here goes your body message';

        // Finally, send it!
        transport.send(envelope)
            .then((_) => print('email sent'))
            .catchError((e) => print('Error: $e'));


        /*if (sendReports.single.sent) {
            _showDiaglog('email sent');
          }
          else {
            _showDiaglog('email not sent');
          }*/
      }
      else {
        _showDiaglog('email not exists');
      }
    }
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

  void sendByPhoneNumber() {
    if(emailController.text == '') {
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
                    "Incorrect or blank phone number",
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
    else {
      phoneController.text = "";
      print(phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {

    final email = TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade200,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
              sendByEmail();
            //Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Send by Email', style: TextStyle(color: Colors.white,fontSize: 18.0),),
              Icon(Icons.email, color: Colors.white,)
            ],
          ),
        ),
      ),
    );

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

    final phoneButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.red.shade200,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            sendByPhoneNumber();
            //Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Send by SMS', style: TextStyle(color: Colors.white,fontSize: 18.0),),
              Icon(Icons.phone, color: Colors.white,)
            ],
          ),
        ),
      ),
    );



    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Password recovery'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            email,
            SizedBox(height: 5.0,),
            emailButton,
            SizedBox(height: 15.0,),
            phone,
            SizedBox(height: 5.0),
            phoneButton,
          ],
        ),
      ),
    );
  }
}
*/

/*
class RP extends StatelessWidget {
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


  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      //Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
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
          onPressed: () async {
            await registerBtn();
            Navigator.pushReplacementNamed(context, "/welcome");
            //Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
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


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    cpController.dispose();
    super.dispose();
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

  Future<Null> registerBtn() async {
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
      final QuerySnapshot numberOfUsers = await Firestore.instance.collection('user').getDocuments();
      var list = numberOfUsers.documents;
      print('length: ${list.length}');
      print('length + 1 ${list.length + 1}');

      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
        Firestore.instance.collection('user');
        await reference.add({"id": list.length + 1, "name": nameController.text, "email": emailController.text, "phone_number": phoneController.text, "password": passwordController.text});
      });

  //print("length: ${n}");

 /*     nameController.text = "";
      emailController.text = "";
      phoneController.text = "";
      passwordController.text = "";
      cpController.text = "";
*/
      print('name: ${nameController.text}');
      print('emailL: ${emailController.text}');
      print('phone number: ${phoneController.text}');
      print('password: ${passwordController.text}');
      print('confirm password: ${cpController.text}');


    }
  }
}
*/

/*
class AV extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new AddVehiclePage();
  }
}
class AddVehiclePage extends StatefulWidget {
  @override
  AddVehiclePageState createState() => new AddVehiclePageState();
}
class AddVehiclePageState extends State<AddVehiclePage> {
  List<String> years = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> countries = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> distanceUnit = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];

  static final sbm = [];
  static final md = ["sdasd","sadasda"];
  var make = {'Acura':[{'model1': ["submod1","submodel2"],'model2':["sub1","subm2"]}],'Audi': [{'model1': ["submodel1","dada"],'model2':["adad","qeqead"]}]};




  List<String> maker = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> model = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> subModel = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> y = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];




  List<DropdownMenuItem<String>> yearList = [];

  void loadData() {
    yearList = [];
    yearList = y.map((val) => new DropdownMenuItem<String>(
        child: new Text(val), value: val,)).toList();

    /*list.add(new DropdownMenuItem(child: new Text("2000"), value: "2000",));
    list.add(new DropdownMenuItem(child: new Text("2001"), value: "2001",));
    list.add(new DropdownMenuItem(child: new Text("2002"), value: "2002",));
    list.add(new DropdownMenuItem(child: new Text("2003"), value: "2003",));
    list.add(new DropdownMenuItem(child: new Text("2004"), value: "2004",));*/
  }
  final nameController = TextEditingController();

  String yearval = null;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context){
    print(make["Acura"][0]["model1"]);

    final nameLbl = Text('Vehicle Name', style: TextStyle(color: Colors.black,fontSize: 18.0),);
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

    final emailLbl = Text('Year', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final dp = DropdownButton(items: yearList,
      onChanged: (value){
      yearval = value;
          setState(() {
print("selected year ${yearval}");
          });
      },
      hint: new Text('Select year'),
      value: yearval,
    );

    final con = Container(
      /*decoration: BoxDecoration(
        //color: Colors.brown,
        borderRadius: BorderRadius.circular(32.0),
        border: Border(right: BorderSide(width: 20.0),left: BorderSide(width: 20.0),bottom: BorderSide(width: 10.0),top: BorderSide(width: 10.0))
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),*/
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: yearList,

        onChanged: (value){
          yearval = value;
          setState(() {
            print("selected year ${yearval}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select year'),
        value: yearval,
      ),
    );

    /*final email = TextFormField(
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
          onPressed: () async {
            await registerBtn();
            Navigator.pushReplacementNamed(context, "/welcome");
            //Navigator.pushReplacementNamed(context, "/welcome");
            // Navigator.of(context).pushNamed(HomePage.tag);
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
    );*/


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Vehicle'),
        centerTitle: true,
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
            emailLbl,
            SizedBox(height: 5.0,),
            con,
            ],
        ),
      ),
    );
  }
}*/

/*
class VehicleDetails extends MaterialPageRoute<Null> {
  VehicleDetails() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(t),
        centerTitle: true,
      ),
    );
  });
}*/

/*class RegisterCustomer extends MaterialPageRoute<Null> {
  RegisterCustomer() : super(builder: (BuildContext cntx) {

    //create_and_Open_DB_and_GetData();
    var assetsimage = new AssetImage('assets/logo.png');

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

    final name = TextFormField(
      controller: nameController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText:  'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText:  'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final password = TextFormField(
      controller: phoneNumberController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText:  'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final submitBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.redAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          /*onPressed: () async {
              await insertDataInDB();
              Navigator.push(cntx, MainPage());
          },*/
          onPressed: () {
            Firestore.instance.runTransaction((Transaction transaction) async {
              CollectionReference ref = Firestore.instance.collection('user');
              await ref.add({"name": "${nameController.text}","email": "${emailController.text}","phoneNumber": "${phoneNumberController.text}"});

            });

            Navigator.push(cntx, MainPage());
          },
          minWidth: 200.0,
          height: 42.0,
          color: Colors.redAccent,
          //child: Text('Log In', style: TextStyle(color: Colors.white),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /*Center(
                child: Text('Log In', style: TextStyle(color: Colors.white)),

              ),*/
              Text('Submit', style: TextStyle(color: Colors.white)),
              Icon(Icons.check_circle, color: Colors.white,)
            ],
          ),
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: Text("Register"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Center(

        child: ListView(

          shrinkWrap: false,
          padding: EdgeInsets.only(left: 24.0,right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 5.0,),
            name,
            SizedBox(height: 8.0,),
            email,
            SizedBox(height: 8.0,),
            password,
            SizedBox(height: 10.0,),
            submitBtn,
          ],
        ),
      ),
    );
  });

  static final nameController = TextEditingController();
  static final emailController = TextEditingController();
  static final phoneNumberController = TextEditingController();

  //static Database db;
  static String dbPath;

  /*static Future createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS customer (id INTEGER PRIMARY KEY,name TEXT NOT NULL,email TEXT NOT NULL,number TEXT NOT NULL)""");
    await db.close();
  }*/

  /*static Future create_and_Open_DB_and_GetData() async {
    print("creating database");
    Directory path = await getApplicationDocumentsDirectory();
    dbPath = p.join(path.path, "db2.db");
    print("db path = $dbPath");
    db = await openDatabase(dbPath, version: 1, onCreate: createTable);
  }*/

  static void insertDataInDB() async {
    //create_and_Open_DB_and_GetData();
      print("db path: ${dbPath}");
    print("name: ${nameController.text}");
    print("email: ${emailController.text}");
    print("phone number: ${phoneNumberController.text}");
        Firestore.instance.runTransaction((Transaction transaction) {

        });
    /*try {

        print("db path in try: ${dbPath}");
      db = await openDatabase(dbPath);
      await db.rawQuery('insert into customer(name,email,number) values("${nameController.text}","${emailController.text}","${phoneNumberController.text}")');
      await db.close();

    } catch(e) {
      print("error in insert: $e");
    }*/


  }


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

}*/


/*class About extends MaterialPageRoute<Null> {
  About() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: Text('About'),
        centerTitle: true,
        actions: <Widget>[
          //new IconButton(icon: const Icon(Icons.), onPressed: () {}),
          new PopupMenuButton<Choice>(
            itemBuilder: (BuildContext context) {
              return aboutChoices.map((Choice choice) {
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
           onSelected: _selectAboutChoice,
          ),
        ],
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: new Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                    style: new TextStyle(color: Colors.black,fontSize: 20.0),
                  ),

                )

            ),
          ],
        ),
    ),
    );
  });

  static Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url,forceSafariVC: false,forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<Null>  _launched;
  
 static void _selectAboutChoice(Choice choice) {
   if (choice.title == "Visit Facebook Page") {
     _launched = _launchInBrowser('https://q-sols.com');
   }
   if (choice.title == "Visit Twitter Page") {
     _launched = _launchInBrowser('https://q-sols.com');
   }
   if (choice.title == "Visit Google+ Page") {
     _launched = _launchInBrowser('https://q-sols.com');
   }
   if (choice.title == "Visit Website") {
     _launched = _launchInBrowser('https://q-sols.com');
   }
  }

}*/

/*class Settings extends MaterialPageRoute<Null> {
  Settings() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(t),
        centerTitle: true,
      ),
    );
  });
}*/

/*class MainPage extends MaterialPageRoute<Null> {
  MainPage() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: Text("Aqmar Motors"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data.documents[index]['name']),
                    onTap: () {
                      print("ontap ");
                      try {
                        snapshot.data.documents[index].reference.updateData({
                          'name': 'Ali raza',
                        });
                        /*Firestore.instance.runTransaction((transaction) async {
                          DocumentSnapshot freshSnap = await transaction.get(snapshot.data.documents.reference);
                          await transaction.update(freshSnap.reference, {
                            'name': '1',
                          });
                        });*/
                      } catch(e) {
                        print("exception: $e");
                      }

                    },
                  );
                },

            );
          }

      ),
    );
  });
}*/

/*class IECenter extends MaterialPageRoute<Null> {
  IECenter() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(t),
        centerTitle: true,
      ),
    );
  });
}*/

/*class ContactSupport extends MaterialPageRoute<Null> {
  ContactSupport() : super(builder: (BuildContext cntx) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(t),
        centerTitle: true,
      ),
    );
  });
}*/

/*class Choice {
  const Choice({this.title, this.icon, this.color});

  final String title;
  final IconData icon;
  final Color color;
}

 String t = "";

const List<Choice> choices = const <Choice>[
  const Choice(title: 'View Vehicle Details', icon: Icons.directions_car, color: Colors.purpleAccent),
  const Choice(title: 'Settings', icon: Icons.settings, color: Colors.grey),
  const Choice(title: 'Import/Export Center', icon: Icons.import_export, color: Colors.amber),
  const Choice(title: 'Contact Support..', icon: Icons.face, color: Colors.brown),
  const Choice(title: 'About', icon: Icons.sms_failed, color: Colors.purple),

  //const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  //const Choice(title: 'Boat', icon: Icons.directions_boat),
 // const Choice(title: 'Bus', icon: Icons.directions_bus),
  //const Choice(title: 'Train', icon: Icons.directions_railway),
 // const Choice(title: 'Walk', icon: Icons.directions_walk),
];

const List<Choice> aboutChoices = const <Choice>[
  const Choice(title: "Visit Facebook Page", icon: Icons.public, color: Colors.blue),
  const Choice(title: "Visit Twitter Page", icon: Icons.public, color: Colors.lightBlue),
  const Choice(title: "Visit Google+ Page", icon: Icons.public, color: Colors.red),
  const Choice(title: "Visit Website", icon: Icons.public, color: Colors.blueAccent),

];
*/