import 'package:cloud_firestore/cloud_firestore.dart';

class Story{
  final String ?id;
  final String ?isim;
  final String ?logo;
  final String ?reklamResim;
  final String ?reklamVideo;

  Story({this.id, this.isim, this.logo, this.reklamResim, this.reklamVideo});
  factory Story.dokumandanUret(DocumentSnapshot doc){
    return Story(
      id: doc.id,
      isim: doc.get('isim'),
      logo:  doc.get('logo'),
      reklamResim: doc.get('reklamResim'),
      reklamVideo: doc.get('reklamVideo'),
    );
  }
}