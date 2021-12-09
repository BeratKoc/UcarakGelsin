
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({ Key? key }) : super(key: key);

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  String ?kullaniciAdi, email, password, tpassword;
  final _formAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100,systemNavigationBarColor: Colors.grey.shade100),
         backgroundColor: Colors.grey[100],
        title: Text("Hesap Olustur",style: TextStyle(color: Colors.black),),
      ),
      body:ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return "Kullanıcı adı boş bırakılamaz!";
                      } else if (girilenDeger.trim().length < 4 ||
                          girilenDeger.trim().length > 10) {
                        return "En az 4 en fazla 10 karakter olabilir!";
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Kullanici adini giriniz",
                      labelText: "Kullanici Adi:",
                      errorStyle: TextStyle(fontSize: 16),
                    ),
                    onSaved: (girilendeger) {
                      kullaniciAdi = girilendeger!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return "Email boş bırakılamaz";
                      } else if (!girilenDeger.contains("@")) {
                        return "Girilen deger e-mail formatinda olmalidir";
                      } else if (!girilenDeger.contains(".com")) {
                        return "Girilen deger e-mail formatinda olmalidir";
                      } else {
                        return null;
                      }
                    },
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email:",
                      prefixIcon: Icon(Icons.mail),
                      hintText: "Email adresiniz giriniz",
                      errorStyle: TextStyle(fontSize: 16),
                    ),
                    onSaved: (girilendeger) {
                      email = girilendeger!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (girilenDeger) {
                      password = girilenDeger;
                      if (girilenDeger!.isEmpty) {
                        return "Sifre boş bırakılamaz";
                      } else if (girilenDeger.trim().length < 6) {
                        return "Sifre en az 6 karaterden olusmali";
                      } 
                      else {
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Sifre:",
                      hintText: "Sifrenizi giriniz",
                      errorStyle: TextStyle(fontSize: 16),
                    ),
                    onSaved: (girilendeger) {
                      
                        password = girilendeger!;
                      
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return "Sifre boş bırakılamaz";
                      } else if (girilenDeger.trim().length < 6) {
                        return "Sifre en az 6 karaterden olusmali";
                      } 
                      else if(girilenDeger!=password){
                        return "Sifreler ayni olmalidir";
                      }
                      else {
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Tekrar:",
                      hintText: "Tekrar Sifrenizi giriniz",
                      errorStyle: TextStyle(fontSize: 16),
                    ),
                    onSaved: (girilendeger) {
                     
                        tpassword = girilendeger!;
                      
                    },
                  ),
                  
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text(
                        "Hesap Oluştur",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _kullaniciOlustur,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _kullaniciOlustur() async{

      final _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);

    if (_formAnahtari.currentState!.validate()) {
      _formAnahtari.currentState!.save();
      setState(() {
        yukleniyor = true;
        
      });
      try{
        Kullanici? kullanici=await _yetkilendirmeServisi.emailKayit(email!, password!);
        if(kullanici!=null){
          DataBase().DatabaseKullaniciOlustur(id: kullanici.id,email: kullanici.email,kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      }on FirebaseAuthException catch(hata){
        setState(() {
          yukleniyor=false;
        });
        
        //var snackbar=SnackBar(content: Text(hata.code),);
 // ScaffoldMessenger.of(context).showSnackBar(snackbar);
 turkceUyariGoster(hataCode:hata.code);
      }
        
    }
  }
  void turkceUyariGoster<FirebaseAuthException>({hataCode}){
    String ?mesaj;
      if(hataCode=="email-already-in-use"){
        mesaj="Bu e-mail zaten kullanilmaktadir";
      }
      else if(hataCode=="invalid-email"){
        mesaj="Gecersiz e-mail tipi";
      }
      else if(hataCode=="weak-password"){
        mesaj="Zayif sifre";
      }
      
      var snackbar=SnackBar(content: Text(mesaj!),);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  







    
  }
