import 'package:flutter/material.dart';
import 'package:ucarak_gelsin/models/restoran.dart';
import 'package:ucarak_gelsin/pages/anasayfa.dart';
import 'package:ucarak_gelsin/services/database.dart';
import 'package:ucarak_gelsin/widgets/restoransatis.dart';



class Ara extends StatefulWidget {
  @override
  _AraState createState() => _AraState();
}

class _AraState extends State<Ara> {
  TextEditingController _aramaController = TextEditingController();
  Future<List<Restoran>>? _aramaSonucu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _appBarOlustur(),
      body: _aramaSonucu != null ? sonuclariGetir() : aramaYok(),
    );
  }

  AppBar _appBarOlustur(){
    return AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      backgroundColor: Colors.grey[100],
      title: TextFormField(
        onChanged: (girilenDeger){
          setState(() {
            _aramaSonucu = DataBase().restoranAra(girilenDeger);
          });
        },
        controller: _aramaController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 30.0,),
          suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: (){
            _aramaController.clear();
            setState(() {
              _aramaSonucu = null;
            });
            }),
          border: InputBorder.none,
          fillColor: Colors.grey[100],
          filled: true,
          hintText: "Restoran Ara...",
          contentPadding: EdgeInsets.only(top: 16.0)
        ),
      ),
    );
  }

  aramaYok(){
    return Center(child: Text("Restoran Ara"));
  }

  sonuclariGetir(){
    return FutureBuilder<List<Restoran>>(
      future: _aramaSonucu ,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data!.length == 0){
          return Center(child: Text("Bu arama için sonuç bulunamadı!"));
        }
        else{
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index){
            Restoran restoran = snapshot.data![index];
            return restoranSatiri(restoran);
          }
          );}
      }
      );
  }

  restoranSatiri(Restoran restoran){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RestoranSatis(id: restoran.id,)));
      },
          child: ListTile(
       /* leading: CircleAvatar(
          backgroundImage: restoran.fotoUrl!=""?NetworkImage(restoran.fotoUrl!):AssetImage('assets/images/avatar.png') as ImageProvider,
        ),*/
        leading: Container(
          height: 60,
          width: 60,
          child: Image.network(restoran.logo!),
          
        ),
        trailing: Text(restoran.konum!,style: TextStyle(fontSize: 13),),
        title: Text(restoran.isim!, style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}