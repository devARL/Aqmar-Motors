import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/vehicleDetail.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class AddFuelup extends StatelessWidget {
  AddFuelup(this.indx);

  final int indx;

  @override
  Widget build(BuildContext context) {
    return new AFP(indx: indx,);
  }
}

class AFP extends StatefulWidget {
  AFP({Key key, this.indx}) : super(key: key);
  final int indx;

  @override
  AFState createState() => new AFState(indx);
}

class AFState extends State<AFP> {
  AFState(this.indx);

  int indx = null;
  String nameVal = null;
  final odometerController = TextEditingController(text: '0,000.00');
  final costPerGalController = TextEditingController(text: '0.000');
  final galController = TextEditingController(text: '0.000');
  final totalCostController = TextEditingController(text: '0.00');
  var tm = "";
  var dt = "";
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String fuelVal = null;
  List<DropdownMenuItem<String>> fuelList = [];
  List<String> fuelUp = ["Gasoline Low [Octane:85]","Gasoline Low [Octane:86]","Gasoline Regular [Octane:87]","Gasoline Mid [Octane:88]","Gasoline Mid [Octane:89]","Gasoline High [Octane:90]","Gasoline Premium [Octane:91]","Gasoline Premium [Octane:92]","Gasoline Premium [Octane:93]","Gasoline Super Premium [Octane:94]",
  "Gasoline Super Premium [Octane:95]","Gasoline Super Premium [Octane:98]","Diesel 4D","Diesel Synthetic","Diesel 2D [Cetane: 40]","Diesel 1D [Cetane: 44]","Diesel ULSD [Cetane: 45]",
  "Bioalcohol E15","Bioalcohol E10","Bioalcohol E22 - Gasohol","Bioalcohol E30","Bioalcohol E50","Bioalcohol E85","Bioalcohol E93","Bioalcohol E100","Biodiesel B99",
  "Biodiesel B100","Biodiesel Blend B2","Biodiesel Blend B5","Biodiesel Blend B20 [Cetane: 50]","LPG/CNG Autogas/LPG","LPG/CNG CNG - Methane"];
  String locationVal = null;
  List<DropdownMenuItem<String>> locationList = [];
  List<String> loc = ["Area1","Area2","Area3","Area4"];
  final noteController = TextEditingController();
  List<File> _image = [];
  bool partlChkVal = false;
  bool missedChkVal = false;
  String carDocumentId = null;
  final Connectivity _connectivity = Connectivity();
  int _sliderVal = 50 ;

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
      addFuelup();
    });
  }

  void addFuelup() async {

    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      if (connectionStatus == "ConnectivityResult.wifi" ||
          connectionStatus == "ConnectivityResult.mobile") {

        var arr = [];
        arr.add(nameVal);
        arr.add(odometerController.text);
        arr.add(costPerGalController.text);
        arr.add(galController.text);
        arr.add(totalCostController.text);
        arr.add(dt);
        arr.add(tm);
        arr.add(fuelVal);
        arr.add(locationVal);
        arr.add(noteController.text);
        arr.add(partlChkVal);
        arr.add(missedChkVal);

        final QuerySnapshot numberOfUsers = await Firestore.instance.collection('fuelup').getDocuments();
        var list = numberOfUsers.documents;
        print('length: ${list.length}');
        print('length + 1 ${list.length + 1}');

        Firestore.instance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
          Firestore.instance.collection('fuelup');
          await reference.add({"vehicle_name": nameVal, "odometer": odometerController.text, "cost_per_gallon": costPerGalController.text, "gallons": galController.text,
            "total_cost": totalCostController.text, "date": dt, "time": tm, "fuel_type": fuelVal, "location": locationVal, "note": noteController.text, "user_id": globals.userId,
            "user_car_document_id": carDocumentId, "partial_fuelup": partlChkVal, "missed_fuelup": missedChkVal});
        });

        final QuerySnapshot numberOfUsers1 = await Firestore.instance.collection('fuelup').getDocuments();
        final List<DocumentSnapshot> dcmnts =  numberOfUsers1.documents;

        globals.userFuelupId[dcmnts[dcmnts.length - 1].documentID] = arr;
        globals.userCarFuelupId.clear();

        var fuelupId = [];
        var usrCarDocId = "";

        for (var i = 0; i < dcmnts.length; i++) {
          if(dcmnts.length == 0){
            globals.userCarFuelupId[dcmnts[i]['user_car_document_id']] = dcmnts[i].documentID;
          }
          else{
            if(i == 0){
              usrCarDocId = dcmnts[i]['user_car_document_id'];
              fuelupId.add(dcmnts[i].documentID);
            }
            else{
              if(usrCarDocId == dcmnts[i]['user_car_document_id']) {
                fuelupId.add(dcmnts[i].documentID);
              }
              else{
                globals.userCarFuelupId[usrCarDocId] = fuelupId;
                fuelupId.clear();
                usrCarDocId = dcmnts[i]['user_car_document_id'];
                fuelupId.add(dcmnts[i].documentID);
              }
            }
          }
        }
        print("user car fuelup id: ${globals.userCarFuelupId}");
        print("user fuelup ids: ${globals.userFuelupId}");
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

  @override
  void initState() {
    super.initState();
    nameVal = globals.vehicleName[indx].toString();
    tm = _time.toString();
    dt = _date.toString().substring(0,10);
    carDocumentId = globals.userCarDocumentId[indx].toString();

    fuelList = [];
    fuelList = fuelUp.map((val) =>
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

  @override
  Widget build(BuildContext context) {

    print("device width: ${MediaQuery.of(context).size.width}");

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
      /*decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),*/
    );

    final costGLbl = Text('COST/GAL.', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final costG = TextFormField(
      onEditingComplete: () {
        setState(() {
          var cpg = double.parse(costPerGalController.text);
          var gl = double.parse(galController.text);
          var res = cpg * gl;
          totalCostController.text = res.toString();
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      },
      controller: costPerGalController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.number,
      autofocus: false,
     /* decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),*/
    );

    final gLbl = Text('GALLONS', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final galons = TextFormField(
      onEditingComplete: () {
        setState(() {
          var cpg = double.parse(costPerGalController.text);
          var gl = double.parse(galController.text);
          var res = cpg * gl;
          totalCostController.text = res.toString();
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      },
      controller: galController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.number,
      autofocus: false,
      /*decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),*/
    );

    final costlbl = Text('TOTAL COST', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final tCost = TextFormField(
      onEditingComplete: () {
        setState(() {
          var cpg = double.parse(costPerGalController.text);
          var gl = double.parse(galController.text);
          var res = cpg * gl;
          totalCostController.text = res.toString();
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      },
      controller: totalCostController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.number,
      autofocus: false,
      /*decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),*/
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

    final cdlbl = Text('CITY DRIVING %', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final cdVal = Text('${_sliderVal}%', style: TextStyle(color: Colors.black,fontSize: 15.0),);
    final cdSlider = CupertinoSlider(
    value: _sliderVal.toDouble(),
    min: 0.0,
    max: 100.0,
    onChanged: (double value) { setState(() {
    print("slider value: ${value}");
    _sliderVal = value.toInt();
    });},
    activeColor: Colors.redAccent,
    );



    final fuellbl = Text('FUEL TYPE', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final fuelCon = Container(
      width: (MediaQuery.of(context).size.width / 2),
      child: DropdownButton(items: fuelList,
        onChanged: (value){
          fuelVal= value;
          setState(() {
            print("selected fuelup ${fuelVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select fuelup'),
        value: fuelVal,
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
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      decoration: InputDecoration(
        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final partllbl = Text('PARTIAL FUEL-UP?', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final partlChkBx = Checkbox(
        value: partlChkVal,
      onChanged: (bool value){
          setState(() {
            partlChkVal = value;
          });
      },
    );

    final missedFUlbl = Text('MISSED FUEL-UP?', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),);
    final missedChkBx = Checkbox(
      value: missedChkVal,
      onChanged: (bool value){
        setState(() {
          missedChkVal = value;
        });
      },
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
        title: new Text('New Fuelup'),
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
          padding: EdgeInsets.only(left: 9.0, right: 9.0),
          children: <Widget>[
            SizedBox(height: 5.0),
            nameLbl,
            SizedBox(height: 5.0,),
            name,
            SizedBox(height: 5.0,),
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 5.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      odoLbl,
                      SizedBox(height: 5.0,),
                      odom,
                      /*new TextFormField(
                        controller: odometerController,
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        ),
                      */
                    ],
                  ),
                ),
                Container(
                  width: 5.0,
                ),
                Container(
                  width: 2.0,
                  height: 60.0,
                  color: Colors.grey,
                ),
                Container(
                  width: 5.0,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      new Text('LAST ODOMETER', style: TextStyle(color: Colors.redAccent.shade100,fontSize: 10.0),),
                      SizedBox(height: 15.0,),
                      new Text('14', style: TextStyle(color: Colors.black,fontSize: 15.0),),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: ((MediaQuery.of(context).size.width / 100) * 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      costGLbl,
                      SizedBox(height: 5.0,),
                      costG,
                      /*new TextFormField(
                        controller: costPerGalController,
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                       ),*/
                    ],
                  ),
                ),
                Container(
                  width: 2.0,
                ),
                Container(
                  width: 2.0,
                  height: 60.0,
                  color: Colors.grey,
                ),
                Container(
                  width: 3.0,
                ),
                Container(
                  width: ((MediaQuery.of(context).size.width / 100) * 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      gLbl,
                      SizedBox(height: 5.0,),
                      galons,
                      /*new TextFormField(
                        controller: galController,
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                      ),*/
                    ],
                  ),
                ),
                Container(
                  width: 2.0,
                ),
                Container(
                  width: 2.0,
                  height: 60.0,
                  color: Colors.grey,
                ),
                Container(
                  width: 3.0,
                ),
                Container(
                  width: ((MediaQuery.of(context).size.width / 100) * 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      costlbl,
                      SizedBox(height: 5.0,),
                      tCost,
                      /*new TextFormField(
                        controller: totalCostController,
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      partllbl,
                      partlChkBx
                    ],
                  ),
                ),
                Container(
                  width: 5.0,
                ),
                Container(
                  width: 2.0,
                  height: 60.0,
                  color: Colors.grey,
                ),
                Container(
                  width: 5.0,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      missedFUlbl,
                      missedChkBx,
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 5.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: ((MediaQuery.of(context).size.width / 100) * 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      cdlbl,
                      SizedBox(height: 5.0,),
                      cdVal,
                    ],
                  ),
                ),
                Container(
                  width: ((MediaQuery.of(context).size.width / 100) * 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      cdSlider,
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            dtlbl,
            SizedBox(height: 5.0,),
            dtBtn,
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            tmlbl,
            SizedBox(height: 5.0,),
            tmBtn,
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            fuellbl,
            SizedBox(height: 10.0,),
            fuelCon,
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 10.0,),
            loclbl,
            SizedBox(height: 10.0,),
            locCon,
            Container(height: 3.2,color: Colors.grey,),
            SizedBox(height: 5.0,),
            notelbl,
            SizedBox(height: 10.0,),
            nte,
            SizedBox(height: 5.0,),

            /*odoLbl,
            SizedBox(height: 5.0,),
            odom,
            SizedBox(height: 15.0,),
            costGLbl,
            SizedBox(height: 5.0,),
            costG,
            SizedBox(height: 15.0,),
            gLbl,
            SizedBox(height: 5.0,),
            galons,
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
            cdlbl,
            SizedBox(height: 5.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                cdVal,
                SizedBox(width: 25.0,),
                cdSlider,
              ],
            ),
            SizedBox(height: 10.0,),
            fuellbl,
            SizedBox(height: 10.0,),
            fuelCon,
            SizedBox(height: 10.0,),
            loclbl,
            SizedBox(height: 10.0,),
            locCon,
            SizedBox(height: 5.0,),
            notelbl,
            SizedBox(height: 10.0,),
            nte,
            SizedBox(height: 5.0,),
            partllbl,
            SizedBox(height: 5.0,),
            partlChkBx,
            SizedBox(height: 10.0,),
            missedFUlbl,
            SizedBox(height: 5.0,),
            missedChkBx,
            SizedBox(height: 10.0,),
            */
            SizedBox(height: 10.0,),
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