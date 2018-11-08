import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:aqmar_motors/vehicleDetail.dart';


class AddService extends StatelessWidget {
  AddService(this.indx);

  final int indx;

  @override
  Widget build(BuildContext context) {
    return new AS(indx: indx,);
 }
}