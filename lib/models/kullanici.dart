import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Kullanici{
  final String ?id;
  final String ?kullaniciAdi;
  final String ?email;

  Kullanici({this.id, this.kullaniciAdi, this.email});
  

  factory Kullanici.dokumandanUret(DocumentSnapshot doc){
    return Kullanici(
      id: doc.id,
      kullaniciAdi: doc.get('kullaniciAdi'),
      email: doc.get('email'),

    );
  }
  factory Kullanici.firebasedenUret(User user){
    return Kullanici(
      id: user.uid,
      kullaniciAdi: user.displayName,
      email: user.email,

    );
  }
}