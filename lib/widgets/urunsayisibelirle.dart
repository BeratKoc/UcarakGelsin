import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';
import 'package:ucarak_gelsin/widgets/restoransatis.dart';

class UrunSayisiBelirle extends StatefulWidget {
   final bool ?stokDurumu;
  final  int ?maxAdet;
  final  int ?stokAdet;
  final String ?listedenGelenId;
  int ?count;

  
  UrunSayisiBelirle({this.stokDurumu, this.maxAdet, this.stokAdet, this.listedenGelenId, this.count});
 
  
   
  @override
  _UrunSayisiBelirleState createState() => _UrunSayisiBelirleState();
}

class _UrunSayisiBelirleState extends State<UrunSayisiBelirle> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    if(widget.stokDurumu==true){
      RestoranSatis restoranSatis=RestoranSatis();
      return Container(
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
                        if(counter>0){
                          counter--;
                          widget.count!=counter;
                          print("widgetCount"+widget.count.toString());
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
              '$counter',
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
                         if(counter<control){
                          // AuthService _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);
                          counter++;
                          widget.count!=counter;
                          print(widget.count);
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
                        print(counter);
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
    );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Stok",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
          Icon(Icons.clear,color: Colors.red,size: 30,),
        ],
      );
    }
  }
}
