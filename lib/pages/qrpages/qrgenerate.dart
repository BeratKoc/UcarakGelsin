import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key}) : super(key: key);

  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              QrImage(
                data: controller.text,
                size: 250,
                backgroundColor: Colors.white54,
              ),
              SizedBox(
                height: 40,
              ),
              buildTextField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: 'Enter the Data',
        hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white60),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        suffixIcon: IconButton(
          color: Colors.green.shade100,
          icon: Icon(
            Icons.done_rounded,
            size: 30,
          ),
          onPressed: () {
            setState(() {});
            Fluttertoast.showToast(
                msg: "Üretilen Mesaj: "+controller.text,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        ),
      ),
    );
  }
}
