import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';


class FPPage extends StatelessWidget {
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

 /*       var options = new SmtpOptions()
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
*/

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
