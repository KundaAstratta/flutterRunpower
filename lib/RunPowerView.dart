import 'package:flutter/material.dart';
import 'package:code/RunEltModel.dart';

class RunPowerView extends StatelessWidget {

  final RunElt runElt;
  const RunPowerView ({Key? key, required this.runElt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(runElt.identRunElt.toString(),style:TextStyle(fontSize: 20, color: Colors.white),)),
      body: Column(
        children: [
          Text("ici",style:TextStyle(fontSize: 20, color: Colors.white),),
          SizedBox(
            height: 10,
          ),
          Text(runElt.dateTimeRunELt.timeZoneName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),)

        ],
      ),
    );
  }
}