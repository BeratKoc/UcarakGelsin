import 'package:cloud_firestore/cloud_firestore.dart';

class Urun{
  final String ?id;
  final String ?isim;
  final String ?aciklama;
  final String ?resimUrl;
  final int ?maxAdet;
  final int? stokAdet;
  
  final bool ?stokDurumu;
  final int ?fiyat;
    Urun({this.id, this.isim, this.aciklama, this.resimUrl, this.maxAdet, this.stokAdet, this.stokDurumu,this.fiyat});
  
  factory Urun.dokumandanUret(DocumentSnapshot doc){
    return Urun(
      id: doc.id,
      isim: doc.get('isim'),
      aciklama: doc.get('aciklama'),
      resimUrl: doc.get('resimUrl'),
      maxAdet: doc.get('maxAdet'),
      stokAdet: doc.get('stokAdet'),
      
      stokDurumu: doc.get('stokDurumu'),
      fiyat: doc.get('fiyat'),
    );
  }


  
}