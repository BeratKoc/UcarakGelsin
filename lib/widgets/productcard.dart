import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/services/authservice.dart';

class ProductCard extends StatefulWidget {
  String ?id;
  String ?isim;
  String ?aciklama;
  int ?maxAdet;
  String ?fotoUrl;
  int ?stokAdet;
  bool ?stokDurumu;
  int? fiyat;
  int counter=0;
  ProductCard(this.id,this.isim,this.aciklama,this.maxAdet,this.fotoUrl,this.stokAdet,this.stokDurumu,this.fiyat);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        title: Text(widget.isim!),
        subtitle: RichText(
     text: TextSpan(
          text: widget.aciklama.toString() + " ",
          style: TextStyle(fontSize: 13, color: Colors.black),
          children: <TextSpan>[
             TextSpan(
               text: widget.fiyat.toString()+"TL",                                             //Text(widget.aciklama!+" "+widget.fiyat.toString()+"TL"),
               style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
               ),
             ),
          ]
     ),
),
        trailing: Image.network(widget.fotoUrl!),
        leading: widget.stokDurumu! ?
      
      Container(
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
          Container(
            height: 30,
            width: 30,
            child: Center(
                  child: InkWell(
                    onTap: (){
                      
                      setState(() {
                         AuthService _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);
                        if(widget.counter>0){
                          widget.counter--;
                          print("widgetCounter"+widget.counter.toString());
                          //DataBase().productsSepet(_yetkilendirmeServisi.aktifTiklanilanmagazaId!, widget.listedenGelenId!, counter);
                        }
                        else{
                          Fluttertoast.showToast(msg: "Urun miktari 0 dan az olamaz");
                        }
                       });
                      
                    },
                      child: Icon(
                Icons.remove,
                color: Colors.white,
              ))),
          ),
          Container(
            color: Colors.green,
            height: 30,
            width: 30,
            child: Center(
                child: Text(
              '${widget.counter}',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),
            )),
          ),
          Center(
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                  child: InkWell(
                    onTap: (){
                       setState(() {
                         int ?control;
                          //AuthService _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);
                         if(widget.stokAdet!<=widget.maxAdet!){

                           control=widget.stokAdet!;
                           
                         }
                         else{
                           control=widget.maxAdet!;
                         }
                         if(widget.counter<control){
                          // AuthService _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);
                          widget.counter++;
                         
                          print(widget.counter);
                         // DataBase().productsSepet(_yetkilendirmeServisi.aktifTiklanilanmagazaId!, widget.listedenGelenId!, counter);
                          
                          //DataBase().productsSepet(_yetkilendirmeServisi.aktifTiklanilanmagazaId!, widget.listedenGelenId!, counter);
                          //print(widget.listedenGelenId);
                        }
                        else{
                          if(widget.stokAdet!<=widget.maxAdet!){
                            
                            Fluttertoast.showToast(msg: "Guncel stok Miktari: $control");
                          }else{
                            Fluttertoast.showToast(msg: "Bu icin urun icin max adet $control den fazla olamaz");
                          }
                          
                        }
                        print(widget.counter);
                       });
                       
                    },
                      child: Icon(
                Icons.add,
                color: Colors.white,
              ))),
            ),
          ),
        ],
      ),
    )
    :
    
       Container(
         width: 90,
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(Icons.clear_outlined,color: Colors.black,size: 30,),
          ],
      ),
       ),
    
        
      ),
    );
  }
}