
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ucarak_gelsin/pages/anasayfa.dart';
import 'package:ucarak_gelsin/pages/yonlendir.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class Telefon extends StatefulWidget {
  const Telefon({Key? key}) : super(key: key);

  @override
  _TelefonState createState() => _TelefonState();
}

class _TelefonState extends State<Telefon> {
  MobileVerificationState currentState =
  MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  var _firebaseAuth = FirebaseAuth.instance;
  String initialCountry = 'TR';
  PhoneNumber isoCode = PhoneNumber(isoCode: 'TR');
  String? phoneNumber;
  String? verificationId;
  bool showLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool yukleniyor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileForm(context)
              : getOtpform(context),
          _loadingElements(),
        ],
      ),
    );
  }

  getMobileForm(context){
    return Form(
      key: formKey,
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
              /*TextFormField(
             
              controller: phoneController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white)),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.phone_android_sharp),
                hintText: "+90 Telefon Numarasi giriniz",
                errorStyle: TextStyle(fontSize: 16),
                
                
              ),
              keyboardType: TextInputType.numberWithOptions()),*/
              InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: isoCode,
              textFieldController: phoneController,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                phoneNumber=number.phoneNumber;
              },
            ),
              
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () async {
                formKey.currentState!.validate();
               formKey.currentState!.save();
                print(phoneNumber);
                setState(() {
                  
                  showLoading = true;
                  
                });
                await _firebaseAuth.verifyPhoneNumber(
                    phoneNumber: phoneNumber!,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                      //signInWithPhoneCredential(phoneAuthCredential);
                    },
                    verificationFailed: (verificationFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(verificationFailed.message!)));
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState =
                            MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationId = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {});
              },
              child: Text("SEND")),
        ],
      ),
    );
  }
  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.isoCode = number;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  getOtpform(context) {
    return Form(
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white)),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.login),
                hintText: "Enter Otp",
                errorStyle: TextStyle(fontSize: 16),
              ),
              keyboardType: TextInputType.phone),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId!,
                        smsCode: otpController.text);
                signInWithPhoneCredential(phoneAuthCredential);
               
              },
              child: Text("Verify")),
        ],
      ),
    );
  }

  Widget _loadingElements() {
    if (showLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center();
    }
  }

  void signInWithPhoneCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final AuthCredential =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (AuthCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Yonlendirme()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}
