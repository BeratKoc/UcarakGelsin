import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';
import 'package:ucarak_gelsin/pages/hesapolustur.dart';
import 'package:ucarak_gelsin/pages/sifremiunuttum.dart';
import 'package:ucarak_gelsin/pages/telefon.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';

class Giris extends StatefulWidget {
  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  bool yukleniyor = false;
  String? email, sifre;
  final _formAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _formPart(),
          _loadingElements(),
        ],
      ),
    );
  }

  Widget _loadingElements() {
    if (yukleniyor) {
      return Positioned(
        top: 60,
        left: 60,
        child: CircularProgressIndicator(),
        );
    } else {
      return Center();
    }
  }

  Form _formPart() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: TextFormField(
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white)),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.email_outlined),
                hintText: "Email adresiniz giriniz",
                errorStyle: TextStyle(fontSize: 16),
              ),
              onSaved: (girilenDeger) => email = girilenDeger,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: TextFormField(
              validator: (girilenDeger) {
                if (girilenDeger!.isEmpty) {
                  return "Sifre boş bırakılamaz";
                } else if (girilenDeger.trim().length < 4) {
                  return "Sifre en az 4 karaterden olusmali";
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                prefixIcon: Icon(Icons.lock),
                hintText: "Sifrenizi giriniz",
                errorStyle: TextStyle(fontSize: 16),
                filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)),
              ),
              onSaved: (girilenDeger) => sifre = girilenDeger,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,elevation: 3.0),
                    child: Text(
                      "Hesap Oluştur",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return HesapOlustur();
                      }));
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right:30.0,left: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,elevation: 3.0),
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _girisYap();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          

// with custom text
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: SignInButton(
              
              Buttons.Google,
              text: "Sign In with Google",
              onPressed: () {
                _googleIleGiris();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left:30.0,right: 30.0),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white) ),
              onPressed: (){
              Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SifremiUnuttum()));
            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.password,color: Colors.grey.shade600,),
                SizedBox(width: 15.0,),
                Text('Sifremi Unuttum',style: TextStyle(color: Colors.grey.shade600),),
              ],
            ),),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left:30.0,right: 30.0),
            child: ElevatedButton(
              
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),elevation:  MaterialStateProperty.all<double>(3.0),),
              onPressed: (){
              Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Telefon()));
            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android_sharp,color: Colors.grey.shade600,),
                SizedBox(width: 15,),
                Text('Telefon ile Giris Yap',style: TextStyle(color: Colors.grey.shade600),),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  void _googleIleGiris() async {
    AuthService _authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      yukleniyor = true;
    });
    try {
      Kullanici? kullanici = await _authService.googleIleGiris();
      if (kullanici == null) {
        await DataBase().DatabaseKullaniciOlustur(
            kullaniciAdi: kullanici!.kullaniciAdi,
            email: kullanici.email,
            id: kullanici.id);
      }
      print('Google ile kullaniciUretildi');
    } on FirebaseAuthException catch (e) {
      setState(() {
        yukleniyor = false;
      });
      print(e.code);
    }
  }

  void _girisYap() async {
    AuthService _authService = Provider.of<AuthService>(context, listen: false);

    if (_formAnahtari.currentState != null) {
      if (_formAnahtari.currentState!.validate()) {
        _formAnahtari.currentState!.validate();
        print('Giris işlemlerini başlat');
        _formAnahtari.currentState!.save();
        setState(() {
          yukleniyor = true;
        });
        try {
          await _authService.emailGiris(email!, sifre!);
          print('Email sifre ile kullaniciUretildi');
        } on FirebaseAuthException catch (hata) {
          setState(() {
            yukleniyor = false;
          });
          var mysnack = SnackBar(content: Text(hata.code));
          ScaffoldMessenger.of(context).showSnackBar(mysnack);
        }
      }
    }
  }
}
