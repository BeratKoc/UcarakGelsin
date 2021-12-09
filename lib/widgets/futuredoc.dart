import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucarak_gelsin/services/database.dart';

class ozellikGetir extends StatelessWidget {
  final String ?saticiId;
  final String ?ozellikIsmi;
  final String ?urunId;

  const ozellikGetir({ this.saticiId, this.ozellikIsmi, this.urunId});
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
                  future: DataBase().sepeteUrunOzellikleriGetir(saticiId!,ozellikIsmi!),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                     DocumentSnapshot data= snapshot.data!;
                      return Image.network(data.get(ozellikIsmi));
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                  );
  }
}