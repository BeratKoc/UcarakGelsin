import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';

class AuthService {
  String? aktifKullaniciId;
  String? aktifTiklanilanmagazaId;
  var _firebaseAuth = FirebaseAuth.instance;

  Stream<Kullanici?> get durumTakipcisi {
    return _firebaseAuth
        .authStateChanges()
        .map((event) => _kullaniciOlustur(event!));
  }

  Kullanici? _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Future<Kullanici?> emailKayit(String email, String password) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _kullaniciOlustur(girisKarti.user!);
  }

  Future<Kullanici?> emailGiris(String email, String password) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _kullaniciOlustur(girisKarti.user!);
  }


  void anonimGiris() async {
    var girisKarti = _firebaseAuth.signInAnonymously();
  }

  Future<void> cikisyap() {
    return _firebaseAuth.signOut();
  }

  Future<Kullanici?> googleIleGiris() async {
    GoogleSignInAccount? googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication yetkiKarti = await googleHesabi!.authentication;
    OAuthCredential sifresizGirisKarti = GoogleAuthProvider.credential(
        idToken: yetkiKarti.idToken, accessToken: yetkiKarti.accessToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisKarti);
    return _kullaniciOlustur(girisKarti.user!);
  }
  Future<void> sifremiSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

 /* phoneVerify(String number,) async{
   
  }*/
}
