import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/restoran.dart';
import 'package:ucarak_gelsin/models/urun.dart';
import 'package:ucarak_gelsin/pages/anasayfa.dart';
import 'package:ucarak_gelsin/pages/bottombar/sepetim.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';
import 'package:ucarak_gelsin/widgets/productcard.dart';
import 'package:ucarak_gelsin/widgets/urunsayisibelirle.dart';

class RestoranSatis extends StatefulWidget {
  String? id;
  String? tiklanilanId;

  RestoranSatis({this.id});

  @override
  _RestoranSatisState createState() => _RestoranSatisState();
}

class _RestoranSatisState extends State<RestoranSatis> {
  List<ProductCard> eklenilenUrunler = [];
  @override
  Widget build(BuildContext context) {
    @override
    String? aktifMagazaId = widget.id != null
        ? widget.id
        : Provider.of<AuthService>(context, listen: false)
            .aktifTiklanilanmagazaId;
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Restoran Detaylari"),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.fastfood),
                  text: "Menu",
                ),
                Tab(
                  icon: Icon(Icons.help),
                  text: "Restoran Hakkinda",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  restoranKarti(),
                  urunCart(),
                ],
              ),
              Text("restoran hakkinda bildi"),
            ],
          ),
          bottomNavigationBar: Container(
            height: 70,
            color: Colors.white12,
            child: InkWell(
              onTap: () {
                
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Sepete eklemek istiyor musunuz?'),
                    content: const Text('Emin misiniz!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Iptal'),
                        child: const Text('Iptal'),
                      ),
                      TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            Navigator.pop(context);
                            for (int i = 0; i < eklenilenUrunler.length; i++) {
                              AuthService _yetkilendirmeServisi =
                                  Provider.of<AuthService>(context,
                                      listen: false);
                              eklenilenUrunler[i].counter == 0
                                  ? null
                                  : DataBase().sepetimiAyarla(
                                      _yetkilendirmeServisi.aktifKullaniciId!,
                                      eklenilenUrunler[i].counter,
                                      aktifMagazaId!,
                                      eklenilenUrunler[i].id!);
                            }
                            
                          }),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.red,
                    ),
                    Text('Sepeti onayla'),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget urunKarti() {
    String? aktifMagazaId = widget.id != null
        ? widget.id
        : Provider.of<AuthService>(context, listen: false)
            .aktifTiklanilanmagazaId;
    print(aktifMagazaId);
    return StreamBuilder<QuerySnapshot>(
        stream: DataBase().productsAkis(aktifMagazaId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot x = snapshot.data!;

            List<Urun> aitUrunListe =
                x.docs.map((e) => Urun.dokumandanUret(e)).toList();
            print(aitUrunListe);

            return ListView.builder(
              shrinkWrap: true,
              itemCount: aitUrunListe.length,
              itemBuilder: (BuildContext context, int index) {
                widget.tiklanilanId = aitUrunListe[index].id;
                UrunSayisiBelirle urun = UrunSayisiBelirle(
                    stokDurumu: aitUrunListe[index].stokDurumu!,
                    maxAdet: aitUrunListe[index].maxAdet!,
                    stokAdet: aitUrunListe[index].stokAdet!);

                return ListTile(
                  title: Text(aitUrunListe[index].isim!),
                  subtitle: Text(aitUrunListe[index].aciklama!),
                  trailing: Container(
                    child: Image.network(aitUrunListe[index].resimUrl!),
                  ),
                  leading: urun,
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget urunCart() {
    String? aktifMagazaId = widget.id != null
        ? widget.id
        : Provider.of<AuthService>(context, listen: false)
            .aktifTiklanilanmagazaId;
    print(aktifMagazaId);
    return StreamBuilder<QuerySnapshot>(
        stream: DataBase().productsAkis(aktifMagazaId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot x = snapshot.data!;

            List<Urun> aitUrunListe =
                x.docs.map((e) => Urun.dokumandanUret(e)).toList();
            print(aitUrunListe);

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: aitUrunListe.length,
              itemBuilder: (BuildContext context, int index) {
                widget.tiklanilanId = aitUrunListe[index].id;

                ProductCard productCard = ProductCard(
                    aitUrunListe[index].id,
                    aitUrunListe[index].isim,
                    aitUrunListe[index].aciklama,
                    aitUrunListe[index].maxAdet,
                    aitUrunListe[index].resimUrl,
                    aitUrunListe[index].stokAdet,
                    aitUrunListe[index].stokDurumu);
                eklenilenUrunler.add(productCard);
                print(eklenilenUrunler);
                print("ProductCount.counter" + productCard.counter.toString());
                return productCard;
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget restoranKarti() {
    String? aktifMagazaId = widget.id != null
        ? widget.id
        : Provider.of<AuthService>(context, listen: false)
            .aktifTiklanilanmagazaId;

    return FutureBuilder<Restoran?>(
        future: DataBase().restoranGetir(aktifMagazaId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Restoran restDoc = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.red,
                elevation: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      height: 150,
                      width: 150,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(restDoc.logo!),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            restDoc.isim!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 100,
                        width: 100,
                        child: Column(
                          children: [
                            Text(
                              "${restDoc.konum}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
