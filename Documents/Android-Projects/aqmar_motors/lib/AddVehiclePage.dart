import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

class AddVehicle extends StatelessWidget {
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

  final String url = 'https://raw.githubusercontent.com/arthurkao/vehicle-make-model-data/master/json_data.json';


  /*List<String> maker = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];*/

  /*List<String> subModel = ["2000","2001","2002","2003","2004","2005","2006","2007",
  "2008","2009","2010","2011","2012","2013","2014","2015","2016","2017",
  "2018","2019",];*/

  List<String> m = ["No Model"];
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

  final nameController = TextEditingController();
  final vinController = TextEditingController();

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


   List<DocumentSnapshot> documents = null;

  var dct = {"2000":[{"aurora":["1","2"]},{"toyota":["1","2"]}],
              "2001":[{"auroa":["3","4"]},{"toyota":["2","5"]}],
              "2002":[{"honda":["2","23"]},{"toyota":["1","2"]}]};

  Future<Null> addVeh() async {
    globals.carAdded += 1;

    await Firestore.instance.collection('user').document(globals.userDocumentId).updateData({"carAdded": globals.carAdded});
   // globals.userCarDocumentId.add(documents[0]);


    final QuerySnapshot numberOfUsers = await Firestore.instance.collection('vehicle').getDocuments();
    var list = numberOfUsers.documents;
    print('length: ${list.length}');
    print('length + 1 ${list.length + 1}');


    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
      Firestore.instance.collection('vehicle');
      await reference.add({"id": list.length + 1, "country": cntryVal, "distance_unit": duVal, "engine": engVal, "fuel_tracking": ftVal, "fuel_unit": fuVal,
        "insurance_policy": "", "license_plate": "", "make": makerVal, "type": typeVal, "model": "", "name": nameController.text, "sub_model": "",
        "tire_pressure": "", "tire_size": "", "track_city": trkVal, "transmission": transVal, "user_id": globals.userId, "vehicle_note": "",
        "vehicle_type": typeVal, "year": yearval});
    });

    final QuerySnapshot numberOfUsers1 = await Firestore.instance.collection('vehicle').getDocuments();
    var list1 = numberOfUsers1.documents;

    documents = numberOfUsers1.documents;

    print("${documents[0].documentID}");

    globals.userCarDocumentId.add(documents[0].documentID);
    globals.vehicleName.add(nameController.text);


  }



  Future<String> getSWData() async {
    List data;
  List y = [];
  List mk = [];
  List model = [];
  Iterable<String> lstOfKeys = dct.keys;

  print(dct[lstOfKeys.elementAt(0)]);
  print(lstOfKeys.toString());

    var res = await http
        .get(Uri.decodeFull(url),headers: {"Accept":"application/json"});

    var resBody = json.decode(res.body);
    //data = resBody["results"]; //1
    data = resBody; //2
    //data = resBody; //3
    print(data);

    var yr = "";
    var mkr = "";
    var mdl  = [];
    var dct1 = {};
    var dct2 = {};
    var yrDt = [];

    for( var i = 0 ; i <= data.length; i++ ) {

//      var newDct = null;

      var dict = data[i];
      //y.add(dict["year"]);
     // mk.add(dict["make"]);
     // model.add(dict["model"]);
      print("dict: $dict");
      if (yr == ""){
yr = dict["year"].toString();
mkr = dict["make"];
mdl.add(dict["model"]);
print("yr: $yr");
print("mkr: $mkr");
print("mdl: $mdl");
      }
      else {
        print("error1");
        print("yr: $yr");
        print("mkr: $mkr");
        print("mdl: $mdl");

        if(yr == dict["year"].toString()){
          if(mkr == dict["make"]){

            mdl.add(dict["model"]);

            print("yr: $yr");
            print("mkr: $mkr");
            print("mdl: $mdl");
          }
          else{
            dct1.clear();
            dct1[mkr] = mdl;
            yrDt.add(dct1);


            print("dct1: $dct1");
            print("yrDt: $yrDt");

            mkr = dict["make"];
            mdl.clear();
            mdl.add(dict["model"]);

            print("yr: $yr");
            print("mkr: $mkr");
            print("mdl: $mdl");
          }
        }
        else{
          dct2[yr] = yrDt;

          print("dct2: $dct2");
          print("yrDt: $yrDt");
          yrDt.clear();
          yr = dict["year"];
          mkr = dict["amke"];
          mdl.clear();
          mdl.add(dict["model"]);
          print("yr: $yr");
          print("mkr: $mkr");
          print("mdl: $mdl");
        }
      }
    }
print(dct2);
    setState(() {

    });

    return "Success";
  }

  @override
  void initState() {
    super.initState();
    loadData();
   // getSWData();
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

    final yCon = Container(
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
        title: new Text('Add Vehicle'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add), onPressed: () async {
            await addVeh();
            print("${documents}");
            Navigator.of(context).pop();
          }, tooltip: "Add New vehicle",),

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
          ],
        ),
      ),
    );
  }
}
