import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/vehicleDetail.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class EditVehicle extends StatelessWidget {
  EditVehicle(this.indx);
  final int indx;

  @override
  Widget build(BuildContext context) {
    return new EV(indx: indx,);
 }
}

class EV extends StatefulWidget {
  EV({Key key, this.indx}) : super(key: key);
  final int indx;

  @override
  EVState createState() => new EVState(indx);
}

class EVState extends State<EV> {
  EVState(this.indx);

  String nameVal = null;
  String yearval = null;
  String makerVal = null;
  String typeVal = null;
  String engVal = null;
  String transVal = null;
  String cntryVal = null;
  String duVal = null;
  String fuVal = null;
  String ftVal = null;
  String trkVal = null;
  String tsVal = null;
  String tpVal = null;
  String submodelVal = null;
  String modelVal = null;
  String noteVal = null;
  String lpVal = null;
  String ipVal = null;
  String carDocumentId = null;
  int indx = null;
  bool isUpdated = false;

  final nameController = TextEditingController();
  final vinController = TextEditingController();

  List<DropdownMenuItem<String>> yearList = [];
  List<DropdownMenuItem<String>> makerList = [];
  List<DropdownMenuItem<String>> typeList = [];
  List<DropdownMenuItem<String>> engList = [];
  List<DropdownMenuItem<String>> transList = [];
  List<DropdownMenuItem<String>> cntryList = [];
  List<DropdownMenuItem<String>> duList = [];
  List<DropdownMenuItem<String>> fuList = [];
  List<DropdownMenuItem<String>> ftList = [];
  List<DropdownMenuItem<String>> trkList = [];

  final Connectivity _connectivity = Connectivity();

  List<String> m = ["Acura","Toyata","Suzuki","Honda"];
  List<String> y = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];
  List<String> ty = ["Car","Bike","Trucks"];
  List<String> eng = ["3.0L V6 ELECTRIC/GAS"];
  List<String> trans = ["Automatic Dual Clutch 7 Speed"];
  List<String> cntry = ["US","UK","PAK"];
  List<String> du = ["Miles","Kilometers"];
  List<String> fu = ["Gallons","Litres"];
  List<String> ft = ["Odometer","Trip Distance"];
  List<String> trk = ["Yes","No"];

  @override
  void initState() {
    super.initState();
    nameVal = globals.vehicleName[indx].toString();
    yearval = globals.vehicleYear[indx].toString();
    typeVal = globals.vehicleType[indx].toString();
    cntryVal = globals.vehicleCountry[indx].toString();
    duVal = globals.vehicleDU[indx].toString();
    engVal = globals.vehicleEngine[indx].toString();
    ftVal = globals.vehicleFT[indx].toString();
    fuVal = globals.vehicleFU[indx].toString();
    ipVal = globals.vehicleIP[indx].toString();
    lpVal = globals.vehicleLP[indx].toString();
    makerVal = globals.vehicleMake[indx].toString();
    modelVal = globals.vehicleModel[indx].toString();
    noteVal = globals.vehicleNote[indx].toString();
    submodelVal = globals.vehicleSubModel[indx].toString();
    tpVal = globals.vehicleTP[indx].toString();
    tsVal = globals.vehicleTS[indx].toString();
    trkVal = globals.vehicleTC[indx].toString();
    transVal = globals.vehicleTransmission[indx].toString();
    carDocumentId = globals.userCarDocumentId[indx].toString();

    nameController.text = nameVal;
    loadData();
    // getSWData();
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
            new Text("Loading"),
          ],
        ),
      ),
    );
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      updateVeh();
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

  @override
  void dispose() {
    nameController.dispose();
    vinController.dispose();
    super.dispose();
  }

  void makeMaker(){
    List<String> m = [];

    if (yearval == "2000") {
      m = ["Acura","Toyata","Suzuki","Honda"];
    }
    else {
      m = ["No Model"];
    }
    makerList = [];
    makerList = m.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,
    )).toList();
  }

  void updateVeh() async {

    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      if (connectionStatus == "ConnectivityResult.wifi" ||
          connectionStatus == "ConnectivityResult.mobile") {

        globals.vehicleName[indx] = nameController.text;
        globals.vehicleYear[indx] = yearval;
        globals.vehicleType[indx] = typeVal;
        globals.vehicleCountry[indx] = cntryVal;
        globals.vehicleDU[indx] = duVal;
        globals.vehicleEngine[indx] = engVal;
        globals.vehicleFT[indx] = ftVal;
        globals.vehicleFU[indx] = fuVal;
        globals.vehicleIP[indx] = ipVal;
        globals.vehicleLP[indx] = lpVal;
        globals.vehicleMake[indx] = makerVal;
        globals.vehicleModel[indx] = modelVal;
        globals.vehicleNote[indx] = noteVal;
        globals.vehicleSubModel[indx] = submodelVal;
        globals.vehicleTP[indx] = tpVal;
        globals.vehicleTS[indx] = tsVal;
        globals.vehicleTC[indx] = trkVal;
        globals.vehicleTransmission[indx] = transVal;
        globals.userCarDocumentId[indx] = carDocumentId;

        await Firestore.instance.collection('vehicle').document(carDocumentId).updateData({"country": cntryVal, "distance_unit": duVal, "engine": engVal, "fuel_tracking": ftVal, "fuel_unit": fuVal,
          "insurance_policy": ipVal, "license_plate": lpVal, "make": makerVal, "type": typeVal, "model": modelVal, "name": nameController.text, "sub_model": submodelVal,
          "tire_pressure": tpVal, "tire_size": tsVal, "track_city": trkVal, "transmission": transVal, "vehicle_note": noteVal,
          "vehicle_type": typeVal, "year": yearval, "vin_number": vinController.text});

        //print("index: ${indx}");
        //print("name4 ${globals.vehicleName[indx]}");

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

  void loadData() {
    yearList = [];
    yearList = y.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    makerList = [];
    makerList = m.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    typeList = [];
    typeList = ty.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    engList = [];
    engList = eng.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    transList = [];
    transList = trans.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    cntryList = [];
    cntryList = cntry.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    duList = [];
    duList = du.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    fuList = [];
    fuList = fu.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    ftList = [];
    ftList = ft.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();

    trkList = [];
    trkList = trk.map((val) => new DropdownMenuItem<String>(
      child: new Text(val), value: val,)).toList();
  }

  @override
  Widget build(BuildContext context) {

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

    final typeLbl = Text('Type', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final typeCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: typeList,
        onChanged: (value){
          typeVal = value;
          setState(() {
            print("selected type ${typeVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select type'),
        value: typeVal,
      ),
    );

    final yearLbl = Text('Year', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final yCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: yearList,
      onChanged: (value){
          yearval = value;
          setState(() {
            makeMaker();
            print("selected year ${yearval}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select year'),
        value: yearval,
      ),
    );

    final makerLbl = Text('Make', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final mCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: makerList,
        onChanged: (value){
          makerVal = value;
          setState(() {
            print("selected maker ${makerVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select maker'),
        value: makerVal,
      ),
    );

    final vinLbl = Text('VIN #', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final vinName = TextFormField(
      controller: vinController,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final engLbl = Text('Engine', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final engCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: engList,
        onChanged: (value){
          engVal = value;
          setState(() {
            print("selected engine ${engVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select engine'),
        value: engVal,
      ),
    );

   final transLbl = Text('Transmission', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final transCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: transList,
         onChanged: (value){
          transVal = value;
          setState(() {
            print("selected transmission ${transVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select transmission'),
        value: transVal,
      ),
    );

    final cntryLbl = Text('Country', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final cntryCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: cntryList,
        onChanged: (value){
          cntryVal = value;
          setState(() {
            print("selected country ${cntryVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select country'),
        value: cntryVal,
      ),
    );

    final duLbl = Text('Distance Unit', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final duCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: duList,
          onChanged: (value){
          duVal = value;
          setState(() {
            print("selected distance unit${duVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select distance unit'),
        value: duVal,
      ),
    );

    final fuLbl = Text('Fuel Unit', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final fuCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: fuList,
          onChanged: (value){
          fuVal = value;
          setState(() {
            print("selected fuel unit ${fuVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select Fuel unit'),
        value: fuVal,
      ),
    );

    final ftLbl = Text('Fuel Tracking', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final ftCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: ftList,
        onChanged: (value){
          ftVal = value;
          setState(() {
            print("selected fuel tracking ${ftVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select Fuel tracking'),
        value: ftVal,
      ),
    );

   final trkLbl = Text('Tracking City/Highway', style: TextStyle(color: Colors.black,fontSize: 18.0),);
    final trkCon = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(items: trkList,
          onChanged: (value){
          trkVal = value;
          setState(() {
            print("selected tracking city/ highway ${trkVal}");
          });
        },
        iconSize: 40.0,
        hint: new Text('Select tracking city/highway'),
        value: trkVal,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Vehicle'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: new IconButton(icon: const Icon(Icons.cancel), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new VehicleDetail(indx),
          ));
        }),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.update), onPressed: () async {
            isUpdated = true;
            _onLoading();

            /*await updateVeh();
            print("updated car document id: ${carDocumentId}");
            //Navigator.of(context).pop();

            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new VehicleDetail(indx),
            ));
            */
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
            typeLbl,
            SizedBox(height: 5.0,),
            typeCon,
            SizedBox(height: 15.0,),
            yearLbl,
            SizedBox(height: 5.0,),
            yCon,
            SizedBox(height: 15.0),
            makerLbl,
            SizedBox(height: 5.0,),
            mCon,
            SizedBox(height: 15.0),
            vinLbl,
            SizedBox(height: 5.0,),
            vinName,
            SizedBox(height: 15.0),
            engLbl,
            SizedBox(height: 5.0,),
            engCon,
            SizedBox(height: 15.0),
            transLbl,
            SizedBox(height: 5.0,),
            transCon,
            SizedBox(height: 15.0),
            cntryLbl,
            SizedBox(height: 5.0,),
            cntryCon,
            SizedBox(height: 15.0),
            duLbl,
            SizedBox(height: 5.0,),
            duCon,
            SizedBox(height: 15.0),
            fuLbl,
            SizedBox(height: 5.0,),
            fuCon,
            SizedBox(height: 15.0),
            ftLbl,
            SizedBox(height: 5.0,),
            ftCon,
            SizedBox(height: 15.0),
            trkLbl,
            SizedBox(height: 5.0,),
            trkCon,
            SizedBox(height: 5.0,),
          ],
        ),
      ),
    );
  }
}