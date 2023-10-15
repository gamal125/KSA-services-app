import 'package:flutter/material.dart';
import 'package:services/model/UserModel.dart';

class ReturnScreen extends StatelessWidget {
  static const String routeName = 'ReturnScreen';
  ReturnScreen({required this.model,required this.successValue});
  UserModel model;
var successValue;
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text('<<<<<<<<<<<<<<<${model.name}>>>>>>>>>>>>>>'),
            Text('<<<<<<<<<<<<<<<${successValue}>>>>>>>>>>>>>>'),
          ],
        ),
      ),
    );
  }
}
