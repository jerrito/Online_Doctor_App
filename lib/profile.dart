import 'dart:io';
import 'dart:ui' as ui;

import 'package:encrypt/encrypt.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:project/MainButton.dart';
import 'package:project/MainInput.dart';
import 'package:project/ProfileContainers.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/bottomNavigation.dart';
import 'package:project/displayPicScreen.dart';
import 'package:project/firebase_services.dart';
import 'package:project/main.dart';
import 'package:project/strings.dart';
import 'package:project/user.dart';
import 'package:project/userProvider.dart';
import 'package:provider/provider.dart';

class ProfileUpdate {
  final String imagePath;
  String? check;

  ProfileUpdate({required this.imagePath, this.check});
}

class Profile extends StatefulWidget {
  ProfileUpdate profileUpdate;
  //List<CameraDescription> cameras=[];
  Profile({super.key, required this.profileUpdate});
  // const Profile({Key? key,}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> nameKey = GlobalKey();
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> numberKey = GlobalKey();
  GlobalKey<FormState> locationKey = GlobalKey();
  GlobalKey<FormState> pinKey = GlobalKey();
  GlobalKey<FormState> medicalInfoKey = GlobalKey();
  final LocalAuthentication auth = LocalAuthentication();
  final iv = e.IV.fromLength(16);
  final keys = e.Key.fromUtf8(AppStrings.encryptionKey);

  ui.Image? image;
  UserProvider? userProvider;
  // MedicalProvider? medicalProvider;
  File? _image;
  TextEditingController name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final location = TextEditingController();
  final pinOld = TextEditingController();
  final pinNew = TextEditingController();
  final pinConfirm = TextEditingController();
  // TextEditingController medication = TextEditingController();
  //TextEditingController medicalNote = TextEditingController();

  bool obscure = true;
  int index = 0;
  bool obscure1 = true;
  int index1 = 0;
  bool obscure2 = true;
  bool obscure3 = true;
  bool obscure4 = true;
  int index2 = 0;

  bool saveLoading = false;

  String donor = "donor";
  String bloodType = "bloodType";
  String? bloodTypes = "";
  bool Yes = false;
  bool No = false;
  bool Unknown = true;

  void changeProfilePic({required User? user}) async {
    String? img = user?.image;
    if (widget.profileUpdate.check == "see") {
    } else if (widget.profileUpdate.check == "update") {
      img = widget.profileUpdate.imagePath;
      user?.image = img;

      await updateUser(user: user!);

      Navigator.pushReplacementNamed(context, "profile");
    }
  }

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    // medicalProvider = context.read<MedicalProvider>();
    // var medic=medicalProvider?.getMedicalInfo(phoneNumber: userProvider!.appUser!.number!);
    changeProfilePic(user: userProvider!.appUser);
    super.initState();
  }

  Future<bool> popNot() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // return  Consumer<MedicalProvider>(
    //       builder: (context, medicalProvider, widget) {
    return WillPopScope(
      onWillPop: popNot,
      child: SafeArea(
        child: Scaffold(
            body: Container(
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(210, 230, 250, 0.2),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children:[
                // IconButton(icon:Icon(Icons.arrow_back_ios_new_outlined),
                //     onPressed:(){
                //       Navigator.pop(context);
                //     }),
                Center(
                    child: Text("Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))),
                // IconButton(icon:Icon(Icons.settings,color:Colors.pink),
                // onPressed:(){
                //
                // })
                // ])

                Flexible(
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity, height: 180,
                            color: Color.fromRGBO(210, 230, 250, 0.2),
                            // decoration: ,
                            child: Visibility(
                              child: CircleAvatar(
                                  radius: h_s * 11.25,
                                  backgroundColor: Colors.pink,
                                  child: ProfilePicture(
                                    //key:profile,
                                    radius: h_s * 11,
                                    //child: Text('${userProvider?.appUser?.firstName![0]}'),
                                    name:
                                        '${userProvider?.appUser?.fullname![0]}',

                                    img: '${userProvider?.appUser?.image}',
                                    //img:'https://firebasestorage.googleapis.com/v0/b/wasime.appspot.com/o/data%2Fuser%2F0%2Fcom.example.mobile_money_project%2Fcache%2F14ae4d1e-b1b5-424d-98e0-07f05cd319602261144635358132582.jpg?alt=media&token=b2c3cdfb-941b-48fe-8d5f-ea00532d0a15',
                                    fontsize: 20,
                                  )),
                              visible:
                                  userProvider?.appUser?.image?.isNotEmpty ==
                                      true,
                              replacement: CircleAvatar(
                                backgroundColor: Colors.white,
                                //backgroundImage:SvgPicture.asset("./assets/svgs/user.svg").image,
                                //radius:50,
                                child: SvgPicture.asset(
                                    "./assets/svgs/user.svg",
                                    width: w_s * 22.22,
                                    height: h_s * 10),
                              ),
                            ),
                          ),
                          Positioned(
                            right: h_s * 10.4,
                            bottom: h_s * 2.5,
                            child: CircleAvatar(
                              backgroundColor: Colors.pink,
                              child: IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.white),
                                  onPressed: () async {
                                    await changeProfile(
                                        user: userProvider?.appUser);
                                  }),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: '${userProvider?.appUser?.fullname}',
                        onPressed: () async {
                          await showName(user: userProvider?.appUser);
                        },
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: '${userProvider?.appUser?.email}',
                        onPressed: () {
                          showEmail(user: userProvider?.appUser);
                        },
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: '${userProvider?.appUser?.number}',
                        onPressed: () {
                          showNumber(user: userProvider?.appUser);
                        },
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: 'Medical Information',
                        onPressed: () {
                          authenticate();
                        },
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: 'Change Pin',
                        onPressed: () {
                          pinEdit(user: userProvider?.appUser);
                        },
                      ),
                      SizedBox(height: 20),
                      ContainerProfileInfo(
                        title: 'Logout',
                        onPressed: () {
                          showExitPopup();
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            bottomNavigationBar: BottomNavBar(idx: 3,)),
      ),
    );
    // });
  }

  updateUser({required User user}) async {
    var result = await userProvider?.updateUser(user: user);
    if (result?.status == QueryStatus.Successful) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Profile updated successfully",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));

      return;
    }
    if (result?.status == QueryStatus.Failed) {
      setState(() {
        saveLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content:
            Text("Error saving details", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));
    }
  }

  Future<void> showName({required User? user}) async {
    String? fullname = user?.fullname;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    profileType: "name",
                    keys: nameKey,
                    validator: FullNameValidator,
                    onChanged: (value) {
                      fullname = value;
                    },
                    initialValue: '${userProvider?.appUser?.fullname}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (nameKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.fullname = fullname;
                              await updateUser(user: user!);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  // Future<void> NameEdit({required User? user}) async {
  //   String? fullname = user?.fullname;
  //   showModalBottomSheet<dynamic>(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       isScrollControlled: true,
  //       context: context,
  //       builder:(BuildContext context) {
  //     return StatefulBuilder(
  //         builder: (context, setState) {
  //           return saveLoading ?
  //           Container(
  //               width: double.infinity,
  //               height: 600,
  //               decoration: const BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20),
  //                   )),
  //               child: Center(child: SpinKitFadingCube(
  //                 color: Colors.pink,
  //                 size: 50.0,
  //               ))) :
  //           BottomSheetContainer(
  //               keys: nameKey,
  //               onChanged: (value) {fullname = value;},
  //               initialValue: user?.fullname,
  //               onPressed:saveLoading? null:
  //                   () async {
  //                 setState(() {
  //                   saveLoading = true;
  //                 });
  //                 user?.fullname = fullname;
  //                 await updateUser(user: user!);
  //                 setState(() {
  //                   saveLoading = false;
  //                   Navigator.pushReplacementNamed(context, "profile");
  //                 });
  //               });
  //         }
  //     );
  //   }
  //   );
  // }
  String? phoneNumberValidator(String? value) {
    final pattern = RegExp("([0][2358])[0-9]{8}");

    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid PhoneNumber";
    }

    return null;
  }

  String? FullNameValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]([A-Z][a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid fullname";
    }

    return null;
  }

  String? emailValidator(String? value) {
    final pattern =
        RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return "Invalid Email address";
    }
    return null;
  }

  Future<void> showNumber({required User? user}) async {
    String? number = user?.number;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    keys: numberKey,
                    profileType: "number",
                    onChanged: (value) {
                      number = value;
                    },
                    validator: phoneNumberValidator,
                    initialValue: '0${user?.number?.substring(4)}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (numberKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.number = '+233${number?.substring(1)}';
                              await updateUser(user: user!);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  // Future<void> numberEdit({required User? user}) async {
  //   String? number = user?.number;
  //   showModalBottomSheet<dynamic>(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       isScrollControlled: true,
  //       context: context, builder:
  //       (BuildContext context) {
  //     return StatefulBuilder(
  //         builder: (context, setState) {
  //           return saveLoading ?
  //           Container(
  //               width: double.infinity,
  //               height: 600,
  //               decoration: const BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20),
  //                   )),
  //               child: Center(child: SpinKitFadingCube(
  //                 color: Colors.pink,
  //                 size: 50.0,
  //               ))) :
  //           BottomSheetContainer(
  //               keys: numberKey,
  //               onChanged: (value) {
  //                 number = value;
  //               },
  //               initialValue: "0${user?.number?.substring(4)}",
  //               onPressed: saveLoading ? null :
  //                   () async {
  //                 setState(() {
  //                   saveLoading = true;
  //                 });
  //
  //                 user?.number = "+233${number?.substring(1)}";
  //
  //                 await updateUser(user: user!);
  //                 setState(() {
  //                   saveLoading = false;
  //                   Navigator.pushReplacementNamed(context, "profile");
  //                 });
  //               });
  //         }
  //     );
  //   }
  //   );
  // }
  Future<void> showEmail({required User? user}) async {
    String? email = user?.email;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return saveLoading
                ? DialogLoading()
                : DialogProfile(
                    keys: emailKey,
                    validator: emailValidator,
                    profileType: "email",
                    onChanged: (value) {
                      email = value;
                    },
                    initialValue: '${userProvider?.appUser?.email}',
                    onPressed: saveLoading
                        ? null
                        : () async {
                            if (emailKey.currentState?.validate() == true) {
                              setState(() {
                                saveLoading = true;
                              });

                              user?.email = email;
                              await updateUser(user: user!);
                              setState(() {
                                saveLoading = false;
                                Navigator.pushReplacementNamed(
                                    context, "profile");
                              });
                            }
                          },
                  );
          });
        });
  }

  Future<void> changeProfile({required User? user}) async {
    String? number = user?.email;
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: double.infinity,
                height: 600,
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                child: Column(children: [
                  Text("Choose from camera or gallery",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 50),
                  SecondaryButton(
                      child: Text("Camera"),
                      onPressed: () async {
                        await getCameraImage();
                      },
                      color: Colors.pink,
                      backgroundColor: Colors.pink),
                  SizedBox(height: 20),
                  SecondaryButton(
                      child: Text("Gallery"),
                      onPressed: () async {
                        await getFileImage();
                      },
                      backgroundColor: Colors.greenAccent,
                      color: Colors.greenAccent)
                ]));
          });
        });
  }

  Future<void> locationEdit() async {
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BottomSheetContainer(
              keys: locationKey, initialValue: "Location", onPressed: () {});
        });
  }

  String? oldPinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    } else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    }
    return null;
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    } else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    }
    return null;
  }

  String? confirmPinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return "This field is required";
    }

    // if (pattern.stringMatch(value ?? "") != value) {
    //   return AppStrings.invalidPhoneNumber;
    // }
    else if (pattern.stringMatch(value ?? "") != value) {
      return "Pin is not equal";
    } else if (value != pinNew.text) {
      return "Pin does not match";
    }
    return null;
  }

  String? inputValidator(String? value) {
    if (value?.isEmpty == true) {
      return "This field is required";
    }
    return null;
  }

  Future<void> pinEdit({required User? user}) async {
    String? oldPin = user?.password;
    String? correctPin;
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: double.infinity,
                height: 600,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                margin: EdgeInsets.all(10),
                child: Visibility(
                  visible: !saveLoading,
                  replacement: Center(
                    child: SpinKitFadingCube(
                      color: Colors.pink,
                      size: 50.0,
                    ),
                  ),
                  child: Form(
                    key: pinKey,
                    child: Column(children: [
                      Expanded(
                        child: ListView(children: [
                          SizedBox(height: 10),
                          Center(
                              child: Text("Change Pin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                          SizedBox(height: 40),
                          Text("Enter old pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure,
                            controller: pinOld,
                            validator: oldPinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = false;
                                    index++;
                                    if (index % 2 == 0) {
                                      obscure = true;
                                    }
                                  });
                                },
                                icon: obscure == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                          SizedBox(height: 20),
                          Text("Enter new pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure1,
                            controller: pinNew,
                            validator: pinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure1 = false;
                                    index1++;
                                    if (index1 % 2 == 0) {
                                      obscure1 = true;
                                    }
                                  });
                                },
                                icon: obscure1 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                          SizedBox(height: 20),
                          Text("Confirm new pin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            obscureText: obscure2,
                            controller: pinConfirm,
                            validator: confirmPinValidator,
                            onChanged: (value) {},
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure2 = false;
                                    index2++;
                                    if (index2 % 2 == 0) {
                                      obscure2 = true;
                                    }
                                  });
                                },
                                icon: obscure2 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.black)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.pink)),
                          ),
                        ]),
                      ),
                      SecondaryButton(
                          child: Text("Confirm"),
                          onPressed: saveLoading
                              ? null
                              : () async {
                                  if (pinKey.currentState?.validate() == true) {
                                    setState(() {
                                      saveLoading = true;
                                      correctPin = pinOld.text;
                                      print(correctPin);
                                    });

                                    var userData = user;
                                    print(correctPin);
                                    if (correctPin == userData?.password) {
                                      userData?.password = pinNew.text;
                                      updateUser(user: userData!);
                                      setState(() {
                                        saveLoading = false;
                                        pinConfirm.clear();
                                        pinNew.clear();
                                        pinOld.clear();
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      print("Wrong pin");
                                      setState(() {
                                        saveLoading = false;
                                        pinConfirm.clear();
                                        pinNew.clear();
                                        pinOld.clear();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                            "Entered old pin is wrong",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor:
                                            Color.fromRGBO(20, 100, 150, 1),
                                      ));
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                          color: Colors.pink,
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white),
                      SizedBox(height: 10)
                    ]),
                  ),
                ));
          });
        });
  }

  Future getCameraImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = (await picker.getImage(
      source: ImageSource.camera,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: pickedFile!.path,
          ),
        ));
      } else {
        print('No image selected.');
      }
    });
  }

  Future getFileImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = (await picker.getImage(
      source: ImageSource.gallery,
    ));
    setState(() {
      if (pickedFile != null) {
        // _images?.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: pickedFile!.path,
          ),
        ));
      }
    });
  }

  Future<void> showMedicalInfo({required User? user}) async {
    final encrypter = e.Encrypter(e.AES(keys));
    String? medicalNote = user?.medicalNotes;
    String? medications = user?.medications;
    String? bloodType = user?.medications;
    //bloodTypes = user?.bloodType;

    final enc = e.Key.fromBase64(user!.medications!);
    //  final encrypted = encrypter.encrypt("plainText", iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    medications = encrypter.decrypt(enc, iv: iv);
    medicalNote =
        encrypter.decrypt(e.Key.fromBase64(user.medicalNotes!), iv: iv);
    bloodType = encrypter.decrypt(e.Key.fromBase64(user.bloodType!), iv: iv);
    // String medicationNotes = sha256
    //     .convert(utf8.encode(userProvider!.appUser!.medicalNotes!))
    //     .toString();
    //String? organDonor = user.organDonor;
    // print("${medicalProvider?.appUser?.medicalNotes}");
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: double.infinity,
                height: 600,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                margin: EdgeInsets.all(10),
                child: Visibility(
                  visible: !saveLoading,
                  replacement: Center(
                    child: SpinKitFadingCube(
                      color: Colors.pink,
                      size: 50.0,
                    ),
                  ),
                  child: Form(
                    key: medicalInfoKey,
                    child: Column(children: [
                      Expanded(
                        child: ListView(children: [
                          SizedBox(height: 5),
                          Center(
                              child: Text("Medical Information",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                          SizedBox(height: 10),
                          Text("Medications",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            initialValue: medications == "" ? "" : medications,
                            obscureText: false,
                            // controller: medication,
                            validator: inputValidator,
                            onChanged: (value) {
                              medications = value;
                            },
                          ),
                          SizedBox(height: 10),
                          Text("Medical Notes",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainInput(
                            initialValue: medicalNote == "" ? "" : medicalNote,
                            obscureText: false,
                            //controller: medicalNote,
                            validator: inputValidator,
                            onChanged: (value) {
                              medicalNote = value;
                            },
                          ),
                          SizedBox(height: 10),
                          Text("Organ donor?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: RadioListTile(
                                  title: Text("Yes"),
                                  groupValue: donor,
                                  value: "Yes",
                                  onChanged: (value) {
                                    Unknown = false;
                                    setState(() {
                                      donor = value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 150,
                                child: RadioListTile(
                                  title: Text("No"),
                                  groupValue: donor,
                                  value: "No",
                                  onChanged: (value) {
                                    No = true;
                                    setState(() {
                                      donor = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 150,
                            child: RadioListTile(
                              title: Text("Unknown"),
                              groupValue: donor,
                              value: "Unknown",
                              onChanged: (value) {
                                Unknown = true;
                                setState(() {
                                  donor = value.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton.icon(
                              onPressed: () {
                                showBloodType();
                              },
                              icon: Icon(Icons.bloodtype,
                                  size: 20, color: Colors.red),
                              label: Text("Select Blood Type",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)))
                        ]),
                      ),
                      SecondaryButton(
                          child: Text("Confirm"),
                          onPressed: saveLoading
                              ? null
                              : () async {
                                  if (medicalInfoKey.currentState?.validate() ==
                                      true) {
                                    setState(() {
                                      saveLoading = true;
                                    });
                                    print(medications);
                                    print(medicalNote);
                                    print(bloodType);
                                    print(donor);
                                    user.medications = encrypter
                                        .encrypt(medications!, iv: iv)
                                        .base64;
                                    user.medicalNotes = encrypter
                                        .encrypt(medicalNote!, iv: iv)
                                        .base64;
                                    // user.bloodType = encrypter
                                    //     .encrypt(bloodTypes!, iv: iv)
                                    //     .base64;
                                    // user?.medications = sha256
                                    //     .convert(utf8.encode(medical!))
                                    //     .toString();
                                    // user?.medicalNotes = sha256
                                    //     .convert(utf8.encode(medicalNote!))
                                    //     .toString();
                                    // user?.bloodType = sha256
                                    //     .convert(utf8.encode(bloodTypes!))
                                    //     .toString();
                                    // user?.organDonor = sha256
                                    //     .convert(utf8.encode(donor))
                                    //     .toString();

                                    await updateUser(user: user!);
                                    // await saveMedicalInfo(
                                    //     userProvider?.appUser?.number,
                                    //         bloodType,
                                    //         medical,
                                    //         medicalNote,
                                    //         donor)
                                    //     .whenComplete(() => ScaffoldMessenger
                                    //             .of(context)
                                    //         .showSnackBar(SnackBar(
                                    //             content: Text(
                                    //                 "Profile successfully updated"))));
                                    setState(() {
                                      saveLoading = false;
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                          color: Colors.pink,
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white),
                      SizedBox(height: 10)
                    ]),
                  ),
                ));
          });
        });
  }

  // Future<void> saveMedicalInfo({User? user}) async {
  //   print(userProvider?.appUser?.id);
  //   // var data = <String,dynamic>{
  //   //   "bloodType": bloodType,
  //   //   "id": id,
  //   //   "number": number,
  //   //   "medications": medications,
  //   //   "medicalNotes": medicalNotes,
  //   //   "organDonor": organDonor
  //   // };
  //   // final firestore = FirebaseFirestore.instance;
  //   // var result = await firestore
  //   //     .collection('ayaresapaAccount').doc(userProvider?.appUser?.id).collection('medicalInfo')
  //   //     .doc(userProvider?.appUser?.id).set(data);
  //   // return result;
  //
  // }

  Future<void> showExitPopup() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.black54,
              content: Container(
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(210, 230, 250, 0.2),
                    borderRadius: BorderRadius.circular(20)),
                height: 120,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Are you sure you want to logout?",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                indexed = 0;
                                Navigator.pushReplacementNamed(
                                    context, 'homeScreen');
                              });
                            },
                            child: Text("Yes"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child:
                              Text("No", style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            // shape: const OutlinedBorder(
                            //   side: BorderSide(color: Colors.blue,width: 2,style: BorderStyle.solid)
                            // )
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> showBloodType() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              children: [
                Container(
                  decoration: BoxDecoration(
                      // color: Color.fromRGBO(210, 230, 250, 0.2),
                      borderRadius: BorderRadius.circular(20)),
                  //height: 600,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Please select your blood type",
                          style: TextStyle(color: Colors.black)),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: RadioListTile(
                                title: Text("A+"),
                                groupValue: bloodType,
                                value: "A+",
                                onChanged: (value) {
                                  Unknown = true;
                                  setState(() {
                                    bloodTypes = value.toString();
                                    Navigator.pop(context);
                                  });
                                },
                              )),
                          BloodTypes(
                            type: "A-",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "B+",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "B-",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "AB+",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "AB-",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "H/H",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "O+",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "O-",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                print(bloodType);
                                Navigator.pop(context);
                              });
                            },
                          ),
                          BloodTypes(
                            type: "Unknown",
                            groupValue: bloodType,
                            onChanged: (value) {
                              setState(() {
                                bloodTypes = value.toString();
                                Navigator.pop(context);
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  Future<void> authenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'to view Medical Information',
          options: const AuthenticationOptions(stickyAuth: true));
      if (didAuthenticate == true) {
        showMedicalInfo(user: userProvider?.appUser);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your device does not have support for verifying you "
              "\nTry change device in order to change pin"),
          backgroundColor: Colors.pinkAccent,
        ));
        Navigator.pop(
          context,
        );
      } else if (e.code == auth_error.notEnrolled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Set phone lock or fingerprint\nto change pin"),
          backgroundColor: Colors.pinkAccent,
        ));
        Navigator.pop(
          context,
        );
      } else {
        // ...
        print("norm");
      }
    }
  }
}

class BloodTypes extends StatelessWidget {
  final String type;
  final String groupValue;
  final void Function(String?)? onChanged;
  const BloodTypes(
      {Key? key, required this.type, required this.groupValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: RadioListTile(
            title: Text("$type"),
            groupValue: groupValue,
            value: "$type",
            onChanged: onChanged));
  }
}
