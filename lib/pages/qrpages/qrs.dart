import 'package:flutter/material.dart';
import 'package:ucarak_gelsin/pages/qrpages/qrgenerate.dart';
import 'package:ucarak_gelsin/pages/qrpages/qrscanner.dart';


class Qrs extends StatefulWidget {
  const Qrs({ Key? key }) : super(key: key);

  @override
  _QrsState createState() => _QrsState();
}

class _QrsState extends State<Qrs> {
  int _aktifIcerikNo = 0;
  List<Widget>? _icerikler;
  void initState() {
    super.initState();
    _icerikler = [
      QrScanner(),
      QrGenerator(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          elevation: 0.0,
            title: Text("Qr Kod Üretici & Tarayıcı"),
            
             
        ),
        body: _icerikler![_aktifIcerikNo],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey.shade900,
          currentIndex: _aktifIcerikNo,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Qr Scanner",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Qr Generator",
          ),
        ],
        onTap: (int tiklananNo) {
          setState(() {
            _aktifIcerikNo = tiklananNo;
            print(_aktifIcerikNo);
          });
        },
        ),
        
      ),
      );
  }
}