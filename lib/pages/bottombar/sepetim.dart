

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/kullanici.dart';
import 'package:ucarak_gelsin/models/restoran.dart';
import 'package:ucarak_gelsin/models/urun.dart';
import 'package:ucarak_gelsin/pages/odeme.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';
import 'package:ucarak_gelsin/widgets/restoransatis.dart';

class Sepetim extends StatefulWidget {
  const Sepetim({Key? key}) : super(key: key);

  @override
  _SepetimState createState() => _SepetimState();
}

class _SepetimState extends State<Sepetim> {
  bool yukleniyor=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: urunKarti(),
      floatingActionButton: FloatingActionButton(
        child: Text("Öde"),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreditCardPage()));
      }),
    );
  }

  Widget urunKarti() {
    //String? aktifMagazaId = Provider.of<AuthService>(context, listen: false).aktifTiklanilanmagazaId;
    String aktifKullanici =
        Provider.of<AuthService>(context, listen: false).aktifKullaniciId!;

    // print(aktifMagazaId);
    return StreamBuilder<QuerySnapshot>(
        stream: DataBase().sepetAkis(aktifKullanici),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            
            QuerySnapshot x = snapshot.data!;
            List<QueryDocumentSnapshot> idler=x.docs;
            
            return ListView.builder(
              shrinkWrap: true,
              itemCount: x.docs.length,
              itemBuilder: (BuildContext context, int index) {
                 if (snapshot.hasData) {
                  String? saticiId = x.docs[index].get("satici");
                  String satilanUrunId = x.docs[index].get('urun');
                  String urunId = x.docs[index].id;
                  print("SaticiId:" + saticiId!);
                  print("satilanUrunId:" + satilanUrunId);
                  print("UrunId:" + urunId);

                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestoranSatis(
                                      id: saticiId,
                                    )));
                      },
                      child: FutureBuilder<DocumentSnapshot>(
                        future: DataBase().sepeteIsimGetir(saticiId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot x = snapshot.data!;
                            return Text(x.get('isim'));
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    subtitle: FutureBuilder<DocumentSnapshot>(
                      future: DataBase()
                          .sepeteUrunOzellikleriGetir(saticiId, satilanUrunId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          DocumentSnapshot data = snapshot.data!;
                          return Text(data.get('aciklama'));
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    trailing: FutureBuilder<DocumentSnapshot>(
                      future: DataBase()
                          .sepeteUrunOzellikleriGetir(saticiId, satilanUrunId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          DocumentSnapshot data = snapshot.data!;
                          return Image.network(data.get('resimUrl'));
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        color: Colors.red,
                      ),
                      height: 30,
                      width: 90,
                      child: Row(
                        children: [
                          //burada sepetten silme ozelligini ekleyecegiz
                          Container(
                            height: 30,
                            width: 30,
                            child: FutureBuilder<DocumentSnapshot>(
                              future: DataBase()
                                  .sepeteAdetGetir(aktifKullanici, urunId),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  DocumentSnapshot data = snapshot.data;
                                  int adet = data.get('adet');
                                  print(adet);
                                  return InkWell(
                                    onTap: () {
                                      if (adet > 0) {
                                        adet = adet - 1;
                                        if (adet == 0) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text(
                                                  'Emin misiniz?'),
                                              content: const Text(
                                                  'Siparisiniz silinecek!'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Iptal'),
                                                  child: const Text('Iptal'),
                                                ),
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                              .collection('sepetim')
                                              .doc(aktifKullanici)
                                              .collection('urun')
                                              .doc(urunId)
                                              .delete();
                                                    Navigator.pop(
                                                          context, 'OK');
                                                  }
                                                  
                                                      
                                                  
                                                  
                                                ),
                                              ],
                                            ),
                                          );
                                          
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('sepetim')
                                              .doc(aktifKullanici)
                                              .collection('urun')
                                              .doc(urunId)
                                              .update({
                                            "adet": adet,
                                          });
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                          //adet gosterme alani
                          Container(
                            
                            
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        color: Colors.green,
                      ),
                            child: Center(
                                child: Text(
                              x.docs[index].get('adet').toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17),
                            )),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            );
          } else {
            return Center(child: SizedBox());
          }
        });
    
  }
Widget _loadingElements() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center();
    }
  }

}
