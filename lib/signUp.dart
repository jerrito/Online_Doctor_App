import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/MainButton.dart';
import 'package:project/MainInput.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/firebase_services.dart';
import 'package:project/main.dart';
import 'package:project/otp.dart';
import 'package:project/strings.dart';
import 'package:project/user.dart' as User_main;
import 'package:project/userProvider.dart';
import 'package:provider/provider.dart';

// showExceptionAlertDialog(
// context,
// exception: e,
// title: 'Sign In Failed',
// );

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
  GlobalKey<FormState> form = GlobalKey();
  var firebaseService = FirebaseServices();
  UserProvider? userProvider;
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool checkLoading = true;
  bool loadingOrNot = false;
  int index_2 = 0;
  bool obscure_2 = true;
  String countryCode = "+233";

  List<String> pics = [
    "doctor_1.jpg",
    "doctor_2.jpg",
    "doctor_3.jpg",
    "doctor_4.jpg"
  ];
  String? pic;
  @override
  void initState() {
    pic = (pics[Random().nextInt(pics.length)]).toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(210, 230, 250, 0.2),
                  Color.fromRGBO(210, 230, 250, 0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Visibility(
              visible: !loadingOrNot,
              replacement: Center(
                  child: SpinKitFadingCube(
                color: Colors.pink,
                size: 50.0,
              )),
              child: Form(
                key: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: h_s * 15,
                              backgroundImage: Image.asset(
                                "./assets/images/$pic",
                                height: h / 3,
                                width: w,
                              ).image,
                            ),
                          ),
                          //Center(child: Text("Let's get things going by signing up", style: TextStyle(fontSize: 17, color: Colors.black),)),
                          SizedBox(height: 15),
                          MainInput(
                            validator: FullNameValidator,
                            controller: fullname,
                            label: Text("Full Name"),
                            prefixIcon: Icon(Icons.person), obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),
                          SizedBox(height: 15),
                          MainInput(
                            validator: phoneNumberValidator,
                            controller: phoneNumber,
                            label: Text("Phone Number"),
                            prefixIcon: selectCountry(),
                            keyboardType: TextInputType.number,
                            //  suffixIcon:Icon(Icons.remove_red_eye),
                            obscureText: false,
                          ),
                          SizedBox(height: 15),
                          MainInput(
                            validator: emailValidator,
                            controller: email,
                            label: Text("Email"),
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email), obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          MainInput(
                            validator: pinValidator,
                            controller: password,
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                                icon: obscure_2 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.pink)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    obscure_2 = false;
                                    index_2++;
                                    if (index_2 % 2 == 0) {
                                      obscure_2 = true;
                                    }
                                  });
                                }),
                            obscureText: obscure_2,
                          ),
                        ],
                      ),
                    ),
                    SecondaryButton(
                      child: Text("Signup"),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink,
                      onPressed: loadingOrNot
                          ? null
                          : () async {
                              if (form.currentState?.validate() == true) {
                                setState(() {
                                  loadingOrNot = true;
                                });
                                await ayaresapaRegister();

                                // Navigator.pushNamed(context,"homepage");
                              }
                            },
                      color: Colors.pink,
                    ),
                    Center(
                        child: Row(
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          child: const Text("Signin"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "login");
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )));
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    } else if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.isNotEqual;
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    final pattern = RegExp("([0][2358])[0-9]{8}");

    // if (pattern.stringMatch(value ?? "") != value) {
    //   return AppStrings.invalidPhoneNumber;
    // }
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
  }

  String? FullNameValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]+([A-Z][a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidFullName;
    }

    return null;
  }

  String? NameValidator(String? value) {
    final pattern = RegExp("[A-Z]([a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidName;
    }

    return null;
  }

  String? emailValidator(String? value) {
    final pattern =
        RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidEmails;
    }
    return null;
  }

  Future<void> ayaresapaRegister() async {
    print("sup");
    String completePhoneNumber = "$countryCode${phoneNumber.text}";
    var result_main =
        await FirebaseServices().getUser(phoneNumber: completePhoneNumber);

    print(result_main?.status);
    if (result_main?.status == QueryStatus.Successful) {
      var user_old = result_main?.data;
      if (user_old?.number == completePhoneNumber) {
        setState(() {
          loadingOrNot = false;
        });
        print("Account already exist");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Account already exist",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(20, 100, 150, 1),
        ));

        // PrimarySnackBar(context).displaySnackBar(
        //   message: AppStrings.accountExistErrorMessage,
        //   backgroundColor: AppColors.errorRed,
        // );

        return;
      }
      phoneSignIn(phoneNumber: "$countryCode${phoneNumber.text}");
    }
    setState(() {
      loadingOrNot = false;
    });
    // print("Account error");
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(duration: Duration(seconds: 5),
    //       content: Text("Error registering account",style:TextStyle(color:Colors.white)),
    //       backgroundColor: Color.fromRGBO(20, 100, 150, 1),));
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    print(" ${authCredential.verificationId}");
    User? user = FirebaseAuth.instance.currentUser;

    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await auth.signInWithCredential(authCredential);
        }
      }
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    print("verification failed ${exception.message}");
    if (exception.code == 'invalid-phone-number') {}
    setState(() {
      loadingOrNot = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Verification failed. Please try again",
          style: TextStyle(color: Colors.white)),
      backgroundColor: Color.fromRGBO(20, 100, 150, 1),
    ));
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    print(verificationId);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerify(
            otpRequest: OTPRequest(
                forceResendingToken: forceResendingToken,
                verifyId: verificationId,
                phoneNumber: "$countryCode${phoneNumber.text}",
                //name: username.text,
                see: "register",
                onSuccessCallback: () async {
                  var user = User_main.User(
                      number: "$countryCode${phoneNumber.text}",
                      fullname: fullname.text,
                      email: email.text,
                      password: password.text,
                      bloodType: "",
                      medications: "",
                      medicalNotes: "",
                      organDonor: "");
                  var result = await FirebaseServices().saveUser(user: user);
                  if (result?.status == QueryStatus.Successful) {
                    finalRegister();
                    // await uploadingData(name.text, number.text, airtime.toString(),
                    // data.toString(), sms.toString(), pin1.text);

                    //await Navigator.pushNamed(context, 'momoHomePage');
                  }
                }),
          ),
        ),
      );
    });
  }

  void finalRegister() async {
    userProvider = context.read<UserProvider>();
    print("Account success");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text("Successfully registered",
          style: TextStyle(color: Colors.white)),
      backgroundColor: Color.fromRGBO(20, 100, 150, 1),
    ));
    var result2 = await userProvider?.getUser(
        phoneNumber: "$countryCode${phoneNumber.text}");
    print(result2?.status);
    if (result2?.status == QueryStatus.Successful) {
      navigate();
    }
  }

  navigate() {
    return Navigator.pushNamed(context, 'homepage');
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  Widget selectCountry() {
    return CountryCodePicker(
        onInit: (val) {
          print(val);
          countryCode = val.toString();
          print(countryCode);
        },
        initialSelection: "GH",
        favorite: const [
          "GH",
          "USA",
        ],
        onChanged: (val) {
          print(val);
          countryCode = val.toString();
          print(countryCode);
        });
  }
}
