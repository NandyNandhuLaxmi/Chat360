import 'package:chatapp/constants.dart';
import 'package:chatapp/helper/loading.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String phoneNo, smssent;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController(text: '+91');
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  bool showLoading = false;

  // Future<void> verfiyPhone() async {
  //   // final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
  //   //   this.verificationId = verId;
  //   // };
  //   // final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
  //   //   this.verificationId = verId;
  //   //   smsCodeDialoge(context).then((value) {
  //   //     print("Code Sent");
  //   //   });
  //   // };
  //   // final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {};
  //   // final PhoneVerificationFailed verifyFailed = (AuthException e) {
  //   //   print('${e.message}');
  //   // };
  //   await _auth.verifyPhoneNumber(
  //     timeout: const Duration(seconds: 5),
  //     phoneNumber: phoneController.text,
  //     verificationCompleted: (phoneAuthCredential) async {
  //       setState(() {
  //         showLoading = false;
  //       });
  //       //signInWithPhoneAuthCredential(phoneAuthCredential);
  //     },
  //     verificationFailed: (verificationFailed) async {
  //       setState(() {
  //         showLoading = false;
  //       });
  //       // _scaffoldKey.currentState!.showSnackBar(SnackBar(
  //       //     content: Text(verificationFailed.message ?? '')));
  //     },
  //     codeSent: (String verId, [int forceCodeResent]) {
  //       setState(() {
  //         showLoading = false;
  //         currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
  //         this.verificationId = verificationId;
  //       });
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) async {},
  //   );
  // }

  getMobileFormWidget(context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width / 1.1,
          child: Text(
            "Fill the mobile number to become our app ",
            style: TextStyle(
              fontSize: 34,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: size.height / 10,
        ),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            // prefixIcon: Icon(EvaIcons.phoneOutline),
            hintText: 'phone number',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 52.0,
          width: size.width / 1.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: kPrimaryColor,
          ),
          child: RaisedButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                timeout: const Duration(seconds: 5),
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  //signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(verificationFailed.message ?? '')));
                },
                codeSent: (String verId, [int forceCodeResent]) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("SEND"),
            color: kPrimaryColor,
            textColor: Colors.white,
          ),
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      Container(
        width: size.width / 1.1,
        child: Text(
          "We sent you an SMS code",
          style: TextStyle(
            fontSize: 34,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        width: size.width / 1.1,
        child: Row(
          children: [
            Text(
              "On number",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2),
            Text(
              phoneController.text,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: size.height / 10,
      ),
      TextField(
        controller: otpController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter OTP",
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Container(
        height: 52.0,
        width: size.width / 1.11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kPrimaryColor,
        ),
        child: RaisedButton(
          onPressed: () async {
            AuthCredential credential = PhoneAuthProvider.getCredential(
              verificationId: verificationId,
              smsCode: otpController.text,
            );
            signInWithPhoneAuthCredential(credential);
          },
          child: Text("VERIFY"),
          color: kPrimaryColor,
          textColor: Colors.white,
        ),
      ),
    ]);
  }

  void signInWithPhoneAuthCredential(AuthCredential credential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential = await _auth.signInWithCredential(credential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      }
    } on AuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(elevation: 0, backgroundColor: Color(0xFFFAFAFA)),
        body: Container(
          child: showLoading
              ? Loading()
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}

//OTP Screen

