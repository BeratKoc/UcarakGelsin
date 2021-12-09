import 'package:cloud_firestore/cloud_firestore.dart';

class Restoran{
 final String ?id;
 final String ?isim;
 
 final String?konum;
 final String?logo;
 final bool? durum;

  Restoran({this.logo,this.id, this.isim, this.konum, this.durum});
   
  factory Restoran.dokumandanUret(DocumentSnapshot doc){
    return Restoran(
      id: doc.id,
      isim: doc.get('isim'),
      konum:  doc.get('konum'),
      logo: doc.get('logo'),
      durum: doc.get('durum'),
    );
  }
}