

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';
import 'package:ucarak_gelsin/models/restoran.dart';
import 'package:ucarak_gelsin/models/urun.dart';

class DataBase {
  final FirebaseFirestore _fb = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();
  Future<void> DatabaseKullaniciOlustur({id, email, kullaniciAdi}) async {
    await _fb.collection("kullanicilar").doc(id).set({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "olusturulmaZamani": zaman,
    });
  }

  Future<Kullanici?> DatabasedenKullaniciGetir(id) async {
    DocumentSnapshot documentSnapshot =
        await _fb.collection('kullanicilar').doc(id).get();
    if (documentSnapshot.exists) {
      return Kullanici.dokumandanUret(documentSnapshot);
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> restoranStoryAkis() {
    return _fb.collection('story').snapshots();
  }

  Future<Restoran?> restoranGetir(String id) async {
    DocumentSnapshot doc = await _fb.collection('restoranlar').doc(id).get();
    if (doc.exists) {
      return Restoran.dokumandanUret(doc);
    }
  }

  Stream<QuerySnapshot> restoranAkis() {
    return _fb.collection('restoranlar').snapshots();
  }

  Future<int?> restoranSayisi() async {
    QuerySnapshot doc = await _fb.collection('restoranlar').get();
    return doc.docs.length;
  }

  Stream<QuerySnapshot> productsAkis(String aktifMagazaId) {
    return _fb
        .collection('products')
        .doc(aktifMagazaId)
        .collection('owner')
        .snapshots();
  }
/*
  Future<void> productsSepet(
      String aktifMagazaId, String tiklanilanUrununId, int adet) async {
    await _fb
        .collection('products')
        .doc(aktifMagazaId)
        .collection('owner')
        .doc(tiklanilanUrununId)
        .update({
      "sepeteEklenecekAdet": adet,
    });
  }*/
   


  
/*
  Future<void> productsSepetAkis(
      String aktifMagazaId, String tiklanilanUrununId, int adet) async {
    await _fb
        .collection('products')
        .doc(aktifMagazaId)
        .collection('owner')
        .doc(tiklanilanUrununId).
        get(); 
  }*/

  
  
   Future<void> adetBelirle(String aktifKullanici,String aktifMagazaId,String tiklanilanUrununId,int adet)async{
  await _fb.collection('sepetim').doc(aktifKullanici).collection('magazalar').doc(aktifMagazaId).collection('eklenilenUrunler').doc(tiklanilanUrununId).update({
    "adet":adet,
  }); }
  Future<void> adetBelirles(String aktifKullanici,String aktifMagazaId,String tiklanilanUrununId,int number)async{
  await _fb.collection('basket').doc(aktifKullanici).collection('shop').doc(aktifMagazaId).collection('product').doc(tiklanilanUrununId).update({
    "adet":number,
  }); }
 

   Future<List<Restoran>> restoranAra(String girilenDeger)async{
   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("restoranlar").where('isim',isGreaterThanOrEqualTo: girilenDeger).get();
  return querySnapshot.docs.map((e) => Restoran.dokumandanUret(e)).toList();

  }
  /*
  Stream<List<Restoran>> restoranAraStream(String girilenDeger){
   Stream<QueryDocumentSnapshot> querySnapshot=  FirebaseFirestore.instance.collection("restoranlar").where('isim',isGreaterThanOrEqualTo: girilenDeger).snapshots();
  return querySnapshot.map((event) => );
  
  }*/
  /*
  Future<int> initialStok(String aktifMagazaId,String tiklanilanUrununId,int adet)async{
  await _fb.collection('products').doc(aktifMagazaId).collection('owner').doc(tiklanilanUrununId).
   
   
   
  }*/

  Future<void> sepetimiAyarla(String aktifKullaniciId, int adet,String satici,String urunId) async {
    await _fb
        .collection('sepetim')
        .doc(aktifKullaniciId)
        .collection('urun').doc().set({
          'adet':adet,
          'urun':urunId,
          'satici':satici,
          
        });
  }

   Stream <QuerySnapshot>sepetAkis(String aktifKullanici){
   return _fb.collection('sepetim').doc(aktifKullanici).collection('urun').snapshots();
   }

   Future<DocumentSnapshot> sepeteIsimGetir(String saticiId)async{
     return await FirebaseFirestore.instance.collection('restoranlar').doc(saticiId).get();
   }
   Future<DocumentSnapshot> sepeteUrunOzellikleriGetir(String saticiId,String urunId)async{
     return await FirebaseFirestore.instance.collection('products').doc(saticiId).collection('owner').doc(urunId).get();
   }
   Future<DocumentSnapshot> sepeteAdetGetir(String aktifKullanici,String degistirilenUrunId)async{
     return await FirebaseFirestore.instance.collection('sepetim').doc(aktifKullanici).collection('urun').doc(degistirilenUrunId).get();
   }
}
