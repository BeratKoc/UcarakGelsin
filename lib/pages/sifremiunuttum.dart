import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:ucarak_gelsin/services/authservice.dart';


class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String ?email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      key: _scaffoldAnahtari,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100,systemNavigationBarColor: Colors.grey.shade100),
        backgroundColor: Colors.grey.shade100,
        elevation: 0.0,
        title: Text("Şifremi Sıfırla",style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: <Widget>[
          yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0,),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: <Widget>[
                  
        
                  TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email adresinizi girin",
              labelText: "Mail:",
              errorStyle: TextStyle(fontSize: 16.0),
              prefixIcon: Icon(Icons.mail),
            ),
            validator: (girilenDeger) {
              if (girilenDeger!.isEmpty) {
                return "Email alanı boş bırakılamaz!";
              } else if (!girilenDeger.contains("@")) {
                return "Girilen değer mail formatında olmalı!";
              }
              return null;
            },
            onSaved: (girilenDeger) => girilenDeger!=null?email = girilenDeger:"abk301@hotmail.com",
        ),
        
        
        SizedBox(height: 50.0,),
        Container(
            width: double.infinity,
            child: OutlinedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,)),
                    onPressed: _sifreyiSifirla,
                    child: Padding(
                      padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                      child: Text(
                        "Şifremi Sıfırla",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          
                      color: Colors.white,
                        ),
                        
                      ),
                    ),
                    
                  ),
        ),
                ],
              )
              ),
          ),
        ],
      ),
    );
  }

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi = Provider.of<AuthService>(context, listen: false);
    
    

    if (_formAnahtari.currentState!.validate()) {
      
      _formAnahtari.currentState!.save();
     
      setState(() {
        yukleniyor = true;
        
      });
      if(email!=null){
        try{
        await _yetkilendirmeServisi.sifremiSifirla(email!);
        
        Navigator.pop(context);
      }on FirebaseAuthException catch(hata){
        setState(() {
          yukleniyor=false;
        });
        
        //var snackbar=SnackBar(content: Text(hata.code),);
 // ScaffoldMessenger.of(context).showSnackBar(snackbar);
 uyariGoster(hataKodu:hata.code);
      }
      }
        
    }
                      
  }

  uyariGoster<FirebaseAuthException>({hataKodu}){
    String ?hataMesaji;

    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Bu mailde bir kullanıcı bulunmuyor";
    }else{
      hataMesaji = "Bir sorunla karşılaşıldı Tekrar-Dene";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

}