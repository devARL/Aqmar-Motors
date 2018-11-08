import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/vehicleDetail.dart';


class Welcome extends StatelessWidget {
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
  //var items = new List<String>();

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    print("globals.isLoggedIn: ${globals.isLoggedIn}");
    //items.add('1');
    //items.add('2');
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

  void  goToAddVehicleScreen() {
    if(globals.carAdded <  5) {
      Navigator.pushNamed(context, "/addVehicle");
    }
    else {
      _showDiaglog('Maximum 5 cars are allowed to add');
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

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: new Drawer(
        child: new Container(
          color: Colors.grey.shade900,
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: new Text(
                    "Username",
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                  //globals.userName
                  //globals.userEmail
                  accountEmail: new Text(
                    'useremail@gmail.com',
                    style: new TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.w500),
                  ),
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text('UN')
                ),



              ),
              /*new DrawerHeader(
                child: new Text("DRAWER HEADER.."),
                decoration: new BoxDecoration(
                  color: Colors.red,
                ),
              ),*/
              new Container(
                height: 60.0 * globals.userCarDocumentId.length,
                child: new ListView.builder(
                  itemCount: globals.userCarDocumentId.length,
                  itemBuilder: (BuildContext context, int index) {
                    //return new Text('Item $index');
                    return ListTile(
                      title: Text('${globals.vehicleName[index]}', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0
                      ), ),
                      onTap: () {
                        Navigator.pop(context);
                        /*Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new VehicleDetail(globals.vehicleName[index].toString(),globals.vehicleYear[index].toString(),
                              globals.vehicleType[index].toString(),globals.vehicleCountry[index].toString(),globals.vehicleDU[index].toString(),
                              globals.vehicleEngine[index].toString(),globals.vehicleFT[index].toString(),globals.vehicleFU[index].toString(),
                              globals.vehicleIP[index].toString(),globals.vehicleLP[index].toString(),globals.vehicleMake[index].toString(),
                              globals.vehicleModel[index].toString(),globals.vehicleNote[index].toString(),globals.vehicleSubModel[index].toString(),
                              globals.vehicleTP[index].toString(),globals.vehicleTS[index].toString(),globals.vehicleTC[index].toString(),
                              globals.vehicleTransmission[index].toString(),globals.userCarDocumentId[index].toString(),index),
                        ));*/
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new VehicleDetail(index),
                        ));
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.add), onPressed: () {
                    Navigator.pop(context);
                    goToAddVehicleScreen();
                  },
                    color: Colors.green,
                  ),
                  new Text('New Vehicle', style: TextStyle(
                      color: Colors.green,
                      fontSize: 20.0
                  ), ),
                ],
              ),
              new Container(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  new Container(width: 20.0,),
                  new Text(
                    'OTHER AREAS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0
                    ),
                  ),
                ],
              ),
              new Divider(height: 15.0,color: Colors.grey.shade700,),
              new Container(
                height: 5.0,
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.sync), onPressed: () {
                    Navigator.pop(context);
                  },
                    color: Colors.green,
                  ),
                  new Text('Set Up Sync', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  ), ),
                ],
              ),
              new Container(
                height: 5.0,
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.alarm), onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/reminders");
                  },
                    color: Colors.green,
                  ),
                  new Text('Reminders', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  ), ),
                ],
              ),
              new Container(
                height: 5.0,
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.settings), onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/settings");
                  },
                    color: Colors.green,
                  ),
                  new Text('Settings', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  ), ),
                ],
              ),
              new Container(
                height: 5.0,
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.email), onPressed: () {
                    Navigator.pop(context);
                  },
                    color: Colors.green,
                  ),
                  new Text('Feedback', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  ), ),
                ],
              ),
              new Container(
                height: 5.0,
              ),
              Row(
                children: [
                  new IconButton(icon: const Icon(Icons.update), onPressed: () {
                    Navigator.pop(context);
                  },
                    color: Colors.green,
                  ),
                  new Text('Upgrade to Premium', style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                  ), ),
                ],
              ),
            ],

          ),
        ),
      ),

      //drawer: new DrawerOnly(),
      appBar: new AppBar(
        /*leading: new IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
        }),*/
        centerTitle: true,
        title: new Text('Welcome'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add), onPressed: () {
            goToAddVehicleScreen();
          }, tooltip: "Add New vehicle",),
          new IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
          }),
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
          new Expanded(
            child: ListView.builder(
          //itemCount: snapshot.data.documents.length,

              itemCount: globals.userCarDocumentId.length,
              itemBuilder: (context, index)
            {

      return ListTile(
      /*title:
                        Text('${items[index]}', style: TextStyle(color: Colors.black, fontSize: 16.0), ),*/
      title: Text('${globals.vehicleName[index]}'),
      onTap: () {
       // Navigator.
        print("index= ${index}");

        Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new VehicleDetail(index),
        ));
        /*Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new VehicleDetail(globals.vehicleName[index].toString(),globals.vehicleYear[index].toString(),
          globals.vehicleType[index].toString(),globals.vehicleCountry[index].toString(),globals.vehicleDU[index].toString(),
          globals.vehicleEngine[index].toString(),globals.vehicleFT[index].toString(),globals.vehicleFU[index].toString(),
          globals.vehicleIP[index].toString(),globals.vehicleLP[index].toString(),globals.vehicleMake[index].toString(),
          globals.vehicleModel[index].toString(),globals.vehicleNote[index].toString(),globals.vehicleSubModel[index].toString(),
          globals.vehicleTP[index].toString(),globals.vehicleTS[index].toString(),globals.vehicleTC[index].toString(),
          globals.vehicleTransmission[index].toString(),globals.userCarDocumentId[index].toString(),index),
        ));*/
      },
      /*onTap: () {
                          print('${items[index]}');
                        },*/
      );
      },
    ),
    ),



        ],
      ),
    );

  }
}

 /*class DrawerOnly extends StatelessWidget {

  @override
  Widget build (BuildContext ctxt) {
    return new Drawer(
      child: new Container(
        color: Colors.grey.shade900,
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(
                  "Username",
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                //globals.userName
                //globals.userEmail
                accountEmail: new Text(
                  'useremail@gmail.com',
                  style: new TextStyle(
                      fontSize: 12.0, fontWeight: FontWeight.w500),
                )
            ),
            /*new DrawerHeader(
                child: new Text("DRAWER HEADER.."),
                decoration: new BoxDecoration(
                  color: Colors.red,
                ),
              ),*/
            new Container(
              height: 60.0 * globals.userCarDocumentId.length,
              child: new ListView.builder(
                itemCount: globals.userCarDocumentId.length,
                itemBuilder: (BuildContext context, int index) {
                  //return new Text('Item $index');
                  return ListTile(
                    title: Text('${globals.vehicleName[index]}', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                    ), ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) => new VehicleDetail(globals.vehicleName[index].toString(),globals.vehicleYear[index].toString(),
                            globals.vehicleType[index].toString(),globals.vehicleCountry[index].toString(),globals.vehicleDU[index].toString(),
                            globals.vehicleEngine[index].toString(),globals.vehicleFT[index].toString(),globals.vehicleFU[index].toString(),
                            globals.vehicleIP[index].toString(),globals.vehicleLP[index].toString(),globals.vehicleMake[index].toString(),
                            globals.vehicleModel[index].toString(),globals.vehicleNote[index].toString(),globals.vehicleSubModel[index].toString(),
                            globals.vehicleTP[index].toString(),globals.vehicleTS[index].toString(),globals.vehicleTC[index].toString(),
                            globals.vehicleTransmission[index].toString(),globals.userCarDocumentId[index].toString()),
                      ));
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.add), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('New Vehicle', style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0
                ), ),
              ],
            ),
            new Container(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                new Container(width: 20.0,),
                new Text(
                  'OTHER AREAS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0
                  ),
                ),
              ],
            ),
            new Divider(height: 15.0,color: Colors.grey.shade700,),
            new Container(
              height: 5.0,
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.sync), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('Set Up Sync', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ), ),
              ],
            ),
            new Container(
              height: 5.0,
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.alarm), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('Reminders', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ), ),
              ],
            ),
            new Container(
              height: 5.0,
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.settings), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('Settings', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ), ),
              ],
            ),
            new Container(
              height: 5.0,
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.email), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('Feedback', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ), ),
              ],
            ),
            new Container(
              height: 5.0,
            ),
            Row(
              children: [
                new IconButton(icon: const Icon(Icons.update), onPressed: () {
                  //goToAddVehicleScreen();
                },
                  color: Colors.green,
                ),
                new Text('Upgrade to Premium', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ), ),
              ],
            ),
          ],

        ),
      ),
    );
  }
}
*/

