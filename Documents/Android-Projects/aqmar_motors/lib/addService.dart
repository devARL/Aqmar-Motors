import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/vehicleDetail.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class AddService extends StatelessWidget {
  AddService(this.indx);

  final int indx;

  @override
  Widget build(BuildContext context) {
    return new AS(indx: indx,);
 }
}

class AS extends StatefulWidget {
  AS({Key key, this.indx}) : super(key: key);
  final int indx;

  @override
  ASState createState() => new ASState(indx);
}

class ASState extends State<AS> {
  ASState(this.indx);

  int indx = null;
  String nameVal = null;
  final odometerController = TextEditingController(text: '0.00');
  final noteController = TextEditingController();
  final costController = TextEditingController(text: '00000');
  List<DropdownMenuItem<String>> serviceList = [];
  List<DropdownMenuItem<String>> locationList = [];
  String serviceVal = null;
  String locationVal = null;

  List<String> loc = ["Area1","Area2","Area3","Area4"];
  List<String> serv = ["A/C System","Air Filter","Battery","Belts","Body/Chassis","Brake Fluid","Brakes,Front","Brakes,Rear","Cabin Air Filter","Car Wash",
  "Clutch Hydraulic Fluid","Clutch Hydraulic System","Cooling System","Diesel Exhaust Fluid","Differential Fluid","Doors","Engine Antifreeze",
  "Engine Oil","Exhaust System","Fuel Filter","Fuel Lines & Pipes","Fuel Pump","Fuel System","Glass/Mirrors","Heating System","Horns",
  "Inspection","Insurance","Lights","Lubricate Chain","New Tires","Oil Filter","Power Steering FLuid","Radiator","Registration","Rust Module",
  "Safety Devices","Spark Plugs","Steering System","Suspension System","Timing Bolt","Tire A","Tire B","Tire C","Tire D","Tire Pressure",
  "Tire Rotation","Transmission Fluid","Water Pump","Wheel Alignment","Windshield Washer Fluid","Windshield Wipers"];

  List<File> _image = [];

  //File _image;

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String carDocumentId = null;


  var tm = "";
  var dt = "";

  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    var a = new Map();
    a[1] = ["heloo wo","das"];
    //print("a[1]:  ${a[1]}");
    print("a: $a");
    //print("a[2] ${a[2]}");
    print("a keys: ${a.keys}");
    print("a values: ${a.values}");
    nameVal = globals.vehicleName[indx].toString();
    tm = _time.toString();
    dt = _date.toString().substring(0,10);
    loadData();
    carDocumentId = globals.userCarDocumentId[indx].toString();
    a[2] = ["sdas",""];
    print("a: $a");
    print("a keys: ${a.keys}");
    print("a values: ${a.values}");
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("saving"),
          ],
        ),
      ),
    );
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      //_login();
      addServ();
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

  Future getImageLib() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image.add(image);
    });
  }

  Future getImageCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image.add(image);
    });
  }

  void loadData() {
    serviceList = [];
    serviceList = serv.map((val) =>
    new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    locationList = [];
    locationList = loc.map((val) =>
    new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Container> _buildListItemsFromPhotos(){
    int index = 0;
    return _image.map((img) {
      var container = Container(
        height: 200.0,
        child: new Row(
          children: <Widget>[
            new Container(
              child: new Image.file(img),
            ),
            SizedBox(width: 20.0,),
          ],
        ),
      );
      index = index + 1;
      return container;
    }).toList();
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime pickedDt = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2017), lastDate: new DateTime(2019));
    if(pickedDt != null) {
      setState(() {
        _date = pickedDt;
        dt = _date.toString().substring(0,10);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay pickedTm = await showTimePicker(context: context, initialTime: _time);
    if(pickedTm != null) {
      setState(() {
        _time = pickedTm;
        tm = _time.toString().substring(10,15);
     });
    }
  }

  void addServ() async {

    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      if (connectionStatus == "ConnectivityResult.wifi" ||
          connectionStatus == "ConnectivityResult.mobile") {

        var arr = [];
        arr.add(nameVal);
        arr.add(odometerController.text);
        arr.add(costController.text);
        arr.add(dt);
        arr.add(tm);
        arr.add(serviceVal);
        arr.add(locationVal);
        arr.add(noteController.text);

        final QuerySnapshot numberOfUsers = await Firestore.instance.collection('service').getDocuments();
        var list = numberOfUsers.documents;
        print('length: ${list.length}');
        print('length + 1 ${list.length + 1}');

        Firestore.instance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
          Firestore.instance.collection('service');
          await reference.add({"vehicle_name": nameVal, "odometer": odometerController.text,
            "total_cost": costController.text, "date": dt, "time": tm, "service_name": serviceVal, "location": locationVal, "note": noteController.text, "user_id": globals.userId,
            "user_car_document_id": carDocumentId});
        });

        final QuerySnapshot numberOfUsers1 = await Firestore.instance.collection('service').getDocuments();
        final List<DocumentSnapshot> dcmnts =  numberOfUsers1.documents;

         globals.userServiceId[dcmnts[dcmnts.length - 1].documentID] = arr;
         globals.userCarServiceId.clear();

        var servId = [];
        var usrCarDocId = "";

        for (var i = 0; i < dcmnts.length; i++) {
          if(dcmnts.length == 0){
            globals.userCarServiceId[dcmnts[i]['user_car_document_id']] = dcmnts[i].documentID;
          }
          else{
            if(i == 0){
              usrCarDocId = dcmnts[i]['user_car_document_id'];
              servId.add(dcmnts[i].documentID);
            }
            else{
              if(usrCarDocId == dcmnts[i]['user_car_document_id']) {
                servId.add(dcmnts[i].documentID);
              }
              else{
                globals.userCarServiceId[usrCarDocId] = servId;
                servId.clear();
                usrCarDocId = dcmnts[i]['user_car_document_id'];
                servId.add(dcmnts[i].documentID);
              }
            }
          }
        }
        print("user car service id: ${globals.userCarServiceId}");
        print("user service ids: ${globals.userServiceId}");
         Navigator.pushReplacement(context, new MaterialPageRoute(
           builder: (BuildContext context) => new VehicleDetail(indx),
         ));
      }
      else{
        _showDiaglog('The Internet connection appears to be offline');
      }
    } on PlatformException catch (e) {
      print("Exception: ${e.toString()}");
      _showDiaglog('Failed to get connectivity.');
    }
  }

    @override
  Widget build(BuildContext context) {

      final nameLbl = Text('VEHICLE NAME', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final name = Text(nameVal,style: TextStyle(
          color: Colors.black,
          fontSize: 15.0
      ),);

      final odoLbl = Text('ODOMETER', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final odom = TextFormField(
        controller: odometerController,
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final costlbl = Text('TOTAL COST', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final tCost = TextFormField(
        controller: costController,
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final dtlbl = Text('DATE', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final dtBtn = FlatButton(
        onPressed: () { _selectDate(context);},
        child: new Text(dt),
      );

      final tmlbl = Text('TIME', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final tmBtn = FlatButton(
        onPressed: () { _selectTime(context);},
        child: new Text(tm),
      );

      final servlbl = Text('SERVICES', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final servCon = Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButton(items: serviceList,
            onChanged: (value){
            serviceVal= value;
            setState(() {
              print("selected servcie ${serviceVal}");
            });
          },
          iconSize: 40.0,
          hint: new Text('Select servcie'),
          value: serviceVal,
        ),
      );

      final loclbl = Text('LOCATIONS', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final locCon = Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButton(items: locationList,
            onChanged: (value){
            locationVal= value;
            setState(() {
              print("selected location ${locationVal}");
            });
          },
          iconSize: 40.0,
          hint: new Text('Select location'),
          value: locationVal,
        ),
      );

      final notelbl = Text('NOTES', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final nte = TextFormField(
        controller: noteController,
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
        keyboardType: TextInputType.multiline,
        autofocus: false,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final phtlbl = Text('PHOTOS', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
      final phtCon = Container(
        height: 200.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: _buildListItemsFromPhotos(),
        ),
      );

     final phtBtnLib = FloatingActionButton(
        onPressed: getImageLib,
        tooltip: 'Pick Image',
        child: new Icon(Icons.photo_library),
      );
      final phtBtnCam = FloatingActionButton(
        onPressed: getImageCam,
        tooltip: 'Pick Image',
        child: new Icon(Icons.photo_camera),
      );

      return new Scaffold(
        appBar: new AppBar(
        title: new Text('New Service'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: new IconButton(icon: const Icon(Icons.cancel), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
          builder: (BuildContext context) => new VehicleDetail(indx),
          ));
        }),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add), onPressed: () {
           _onLoading();
          }),
        ],
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
            odoLbl,
            SizedBox(height: 5.0,),
            odom,
            SizedBox(height: 15.0,),
            costlbl,
            SizedBox(height: 5.0,),
            tCost,
            SizedBox(height: 10.0,),
            dtlbl,
            SizedBox(height: 5.0,),
            dtBtn,
            SizedBox(height: 10.0,),
            tmlbl,
            SizedBox(height: 5.0,),
            tmBtn,
            SizedBox(height: 10.0,),
            servlbl,
            SizedBox(height: 10.0,),
            servCon,
            SizedBox(height: 10.0,),
            loclbl,
            SizedBox(height: 10.0,),
            locCon,
            SizedBox(height: 5.0,),
            notelbl,
            SizedBox(height: 10.0,),
            nte,
            SizedBox(height: 5.0,),
            phtlbl,
            SizedBox(height: 5.0,),
            phtCon,
            SizedBox(height: 5.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                phtBtnCam,
               Container(width: 25.0,),
               phtBtnLib,
              ],
            ),
            SizedBox(height: 5.0,),
          ],
        ),
      ),
      );
    }
  }
