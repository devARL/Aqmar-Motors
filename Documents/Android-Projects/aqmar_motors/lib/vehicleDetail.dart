import 'package:flutter/material.dart';
import 'package:aqmar_motors/editVehicle.dart';
import 'package:aqmar_motors/addService.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/addFuelup.dart';

class VehicleDetail extends StatelessWidget {
  VehicleDetail(this.indx);

  final int indx;

  @override
  Widget build(BuildContext context) {
    return new VD(indx: indx,);
  }
}

class VD extends StatefulWidget {
  VD({Key key, this.indx}) : super(key: key);

  final int indx;

  @override
  VDState createState() => new VDState(indx);
}

class VDState extends State<VD> {
  VDState(this.indx);

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
  }

    @override
  Widget build(BuildContext context) {

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Vehicle Info'),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: <Widget>[
            new PopupMenuButton(
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        new PopupMenuItem<String>(
          child: new ListTile(title: Text('Edit Vehicle'), leading: new IconButton(icon: const Icon(Icons.edit), onPressed: () {

            Navigator.pop(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new EditVehicle(indx),
            ));
         }),onTap: () {
            Navigator.pop(context);

            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new EditVehicle(indx),
            ));
            },),
        ),

        new PopupMenuItem<String>(
          child: new ListTile(title: Text('Add Fuel'), leading: new IconButton(icon: const Icon(Icons.local_gas_station), onPressed: () {

            Navigator.pop(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new AddFuelup(indx),
            ));
          }),onTap: () {

            Navigator.pop(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new AddFuelup(indx),
            ));
          },)),

      new PopupMenuItem<String>(
          child: new ListTile(title: Text('Add Service'), leading: new IconButton(icon: const Icon(Icons.build), onPressed: () {

            Navigator.pop(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new AddService(indx),
            ));
          }),onTap: () {

            Navigator.pop(context);
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new AddService(indx),
            ));

          },)),

      new PopupMenuItem<String>(
          child: new ListTile(title: Text('Add Note'), leading: new IconButton(icon: const Icon(Icons.event_note), onPressed: () {
           // Navigator.pushNamed(context, "/addVehicle");
          }),onTap: () {
           // Navigator.pushNamed(context, "/addVehicle");
          },)),

      new PopupMenuItem<String>(
          child: new ListTile(title: Text('Add Reminder'), leading: new IconButton(icon: const Icon(Icons.alarm), onPressed: () {
           // Navigator.pushNamed(context, "/addVehicle");
          }),onTap: () {
           // Navigator.pushNamed(context, "/addVehicle");
          },)),

      new PopupMenuItem<String>(
          child: new ListTile(title: Text('Vehicle Logs'), leading: new IconButton(icon: const Icon(Icons.list), onPressed: () {
           // Navigator.pushNamed(context, "/addVehicle");
          }),onTap: () {
           // Navigator.pushNamed(context, "/addVehicle");
          },)),

      ],
      onSelected: (_) {

      }),

          ],
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 5.0),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              Text(
                'VEHICLE NAME',
                style: TextStyle(
                    color: Colors.redAccent.shade100,
                    fontSize: 10.0
                ),
              ),
              Text( nameVal,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0
                ),
              ),
              new Divider(height: 15.0,color: Colors.grey.shade700,),
            ],
          ),
              SizedBox(height: 5.0),
              Row(
                children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YEAR',
                    style: TextStyle(
                        color: Colors.redAccent.shade100,
                        fontSize: 10.0
                    ),
                  ),
                  Text(
                      yearval,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0
                    ),
                  ),
                ],
              ),
                  Container(
                    width: 25.0,
                  ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAKE & MODEL',
                style: TextStyle(
                    color: Colors.redAccent.shade100,
                    fontSize: 10.0
                ),
              ),
              Text(
                "${makerVal} ${modelVal}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0
                ),
              ),

            ],
          ),
          ],
              ),
              new Divider(height: 15.0,color: Colors.grey.shade700,),
              SizedBox(height: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: [
                  Text(
                    'ENGINE',
                    style: TextStyle(
                        color: Colors.redAccent.shade100,
                        fontSize: 10.0
                    ),
                  ),
                  Text(
                      engVal,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0
                    ),
                  ),
                  new Divider(height: 15.0,color: Colors.grey.shade700,),
                ],
              ),
              SizedBox(height: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: [
                  Text(
                    'TRANSMISSION',
                    style: TextStyle(
                        color: Colors.redAccent.shade100,
                        fontSize: 10.0
                    ),
                  ),
                  Text(
                    transVal,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0
                    ),
                  ),
                  new Divider(height: 15.0,color: Colors.grey.shade700,),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LICENSE PLATE',
                        style: TextStyle(
                            color: Colors.redAccent.shade100,
                            fontSize: 10.0
                        ),
                      ),
                      Text(
                        lpVal,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 25.0,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INSURANCE POLICY',
                        style: TextStyle(
                            color: Colors.redAccent.shade100,
                            fontSize: 10.0
                        ),
                      ),
                      Text(
                        ipVal,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              new Divider(height: 15.0,color: Colors.grey.shade700,),
              SizedBox(height: 5.0,),
            ],
          ),
        ),
      );
    }
}