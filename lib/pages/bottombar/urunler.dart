import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ucarak_gelsin/models/restoran.dart';
import 'package:ucarak_gelsin/models/story.dart';
import 'package:ucarak_gelsin/services/authservice.dart';
import 'package:ucarak_gelsin/services/database.dart';
import 'package:ucarak_gelsin/widgets/restoransatis.dart';

import 'package:ucarak_gelsin/widgets/widgetstory.dart';

class Urunler extends StatefulWidget {
  const Urunler({Key? key}) : super(key: key);

  @override
  _UrunlerState createState() => _UrunlerState();
}

class _UrunlerState extends State<Urunler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          StoryStream(),
          RestoranStream(),
      ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot> RestoranStream() {
    return StreamBuilder<QuerySnapshot>(
          stream: DataBase().restoranAkis(),
          builder: (contex,snapshot){
            if(snapshot.hasData){
               QuerySnapshot  q1 =snapshot.data!;
           List<Restoran> restoranlarAkisList= q1.docs.map((e) => Restoran.dokumandanUret(e)).toList();
             return ListView.builder(
               physics: ClampingScrollPhysics(),
               shrinkWrap: true,
                itemCount: q1.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: ()async{
                        AuthService _yetkilendirmeServisi=Provider.of<AuthService>(context,listen: false);
                        _yetkilendirmeServisi.aktifTiklanilanmagazaId=restoranlarAkisList[index].id;
                     
                      
                     await Navigator.push(context, MaterialPageRoute(builder: (context)=>RestoranSatis()));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        backgroundImage: NetworkImage(restoranlarAkisList[index].logo!),
                      ),
                      title: Text(restoranlarAkisList[index].isim!),
                      subtitle: Text(restoranlarAkisList[index].konum!),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.red,),
                    ),
                  );
                },
              );
            }
            else{
            return  Center(child: CircularProgressIndicator());
          }
          }
          
          );
  }

  StreamBuilder<QuerySnapshot> StoryStream() {
    return StreamBuilder<QuerySnapshot>(
          stream: DataBase().restoranStoryAkis(),
          builder: (context,snapshot) {
            if(snapshot.hasData){
              QuerySnapshot  q1 =snapshot.data!;
       List<Story> storyAkisList= q1.docs.map((e) => Story.dokumandanUret(e)).toList();
            return Container(
              height: 100,
              width: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storyAkisList.length,
                itemBuilder: (context,index){
                  return storyItem(storyAkisList[index].logo!);
                },
                
              ),
            );
            }
            
            else{
              return Center(child: CircularProgressIndicator());
            }
        
          }
        );
  }

  Widget storyItem(String url) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>StoryPageView()));
            
          },
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.grey.shade300,
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.green.withOpacity(0.8), spreadRadius: 2.0),
                ]),
          ),
        ),
      ),
    );
  }
  _backFromStoriesAlert() {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(
          "User have looked stories and closed them.",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
        ),
        children: <Widget>[
          SimpleDialogOption(
            child: Text("Dismiss"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
