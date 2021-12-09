import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/pages/giris.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucarak_gelsin/pages/yonlendir.dart';
import 'package:ucarak_gelsin/services/authservice.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Provider<AuthService>(
      create: (_)=>AuthService(),
      child: 
        MaterialApp(
          
          debugShowCheckedModeBanner: false,
              title: 'UcanSepet.net',
              
              theme: ThemeData(
                primarySwatch: Colors.red,),
          home: Yonlendirme(),
        ),
      
    );
  }
}