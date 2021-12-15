import 'package:flutter/material.dart';
import 'package:ucarak_gelsin/pages/qrpages/qrgenerate.dart';
import 'package:ucarak_gelsin/pages/qrpages/qrs.dart';
import 'package:ucarak_gelsin/pages/qrpages/qrscanner.dart';

class myDrawer extends StatefulWidget {
  const myDrawer({ Key? key }) : super(key: key);

  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
            leading: Icon(Icons.person,size: 30,),
            title: Text('Profil',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.person_outline_outlined,size: 30,),
            title: Text('Bilgilerim',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.shop,size: 30,),
            title: Text('Önceki Siparişlerim',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.star,size: 30,),
            title: Text('Favorilerim',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.store_outlined,size: 30,),
            title: Text('Adreslerim',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.credit_card,size: 30,),
            title: Text('Kredi Kartlarim',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet,size: 30,),
            title: Text('Cüzdanım',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: Icon(Icons.add_circle,size: 30,),
            title: Text('Kuponlarım',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Qrs())),
            child: ListTile(
              leading: Icon(Icons.qr_code_rounded,size: 30,color: Colors.black,),
              title: Text('Qr',style: TextStyle(fontSize: 20),),
              trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.green,),
            ),
          ),
        ],
      ),
    );
  }
  
}