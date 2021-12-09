import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/pages/bottombar/ara.dart';
import 'package:ucarak_gelsin/pages/bottombar/sepetim.dart';
import 'package:ucarak_gelsin/pages/bottombar/urunler.dart';
import 'package:ucarak_gelsin/pages/drawer.dart';
import 'package:ucarak_gelsin/pages/giris.dart';
import 'package:ucarak_gelsin/services/authservice.dart';

class Anasayfa extends StatefulWidget {
  final int? aktifIcerikNoSet;

  const Anasayfa({Key? key, this.aktifIcerikNoSet}) : super(key: key);
  
  

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int ?aktifIcerikNo=0;
  //List<Widget>?items;
  PageController ?pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController=PageController();
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    AuthService _authService=Provider.of<AuthService>(context,listen: false);
    return Scaffold(
      drawer: myDrawer(),
      appBar: AppBar(
        elevation: 0.0,
        actions: [IconButton(onPressed: (){
          
        _authService.cikisyap();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Giris()));
      }, icon: Icon(Icons.exit_to_app))],),
      body:PageView(
        onPageChanged: (int acilan){
          setState(() {
            aktifIcerikNo=acilan;
          });
        },
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: [
        Urunler(),
        Ara(),
        Sepetim(),
        
      ],),
      bottomNavigationBar: BottomBar(),
    );
  }

  BottomNavigationBar BottomBar() {
    return BottomNavigationBar(
      currentIndex: aktifIcerikNo!,
      elevation: 0.0,
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Restoranlar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Ara",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_sharp),
          label: "Sepetim",
        ),
      ],
      onTap: (int aktifSayfa){
        
        setState(() {
          aktifIcerikNo=aktifSayfa;
          pageController!.jumpToPage(aktifIcerikNo!);
        });
      },
    );
  }
  
}