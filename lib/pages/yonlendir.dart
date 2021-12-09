

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';
import 'package:ucarak_gelsin/pages/anasayfa.dart';
import 'package:ucarak_gelsin/pages/giris.dart';
import 'package:ucarak_gelsin/services/authservice.dart';


class Yonlendirme extends StatelessWidget {
  const Yonlendirme({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

     final _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);

    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
      builder: (context,snapshot){
        if(snapshot.connectionState== ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if(snapshot.hasData){
          Kullanici? aktifKullanici=snapshot.data as Kullanici;
          _yetkilendirmeServisi.aktifKullaniciId=aktifKullanici.id;
          return Anasayfa();
        }
        else{
          return Giris();
        }
      },
    );
  }
}