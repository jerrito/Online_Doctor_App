import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/MainButton.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/bottomNavigation.dart';
import 'package:project/homeContainers.dart';
import 'package:project/main.dart';
import 'package:project/mongo.dart';
import 'package:project/user.dart';

class DoctorsAvailable extends StatefulWidget {
  const DoctorsAvailable({Key? key}) : super(key: key);

  @override
  State<DoctorsAvailable> createState() => _DoctorsAvailableState();
}

class _DoctorsAvailableState extends State<DoctorsAvailable> {
  int indexed = 0;
  bool search = false;
  bool searching = true;
  double searchWidth = 150;
  FocusNode? online;
  bool onlineCheck = true;
  bool followingCheck = false;
  FocusNode? following;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        // appBar: AppBar(
        //   leading: ,
        //   title: ,
        //   centerTitle: true,
        //   actions: [
        //
        //   ],
        // ),
        body: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(210, 230, 250, 0.2)
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color.fromRGBO(210, 230, 250, 0.2),
                    //     Color.fromRGBO(210, 230, 250, 0.2)
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    ),
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    height: h_s * 6.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onFocusChange: (focus) {
                            onlineCheck = false;
                            followingCheck = true;
                          },
                          focusNode: online,
                          autofocus: onlineCheck,
                          onPressed: () {
                            setState(() {
                              onlineCheck = true;
                              followingCheck = false;
                            });
                          },
                          child: Text("Online",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: onlineCheck
                                      ? Colors.pink
                                      : Colors.black)),
                        ),
                        const VerticalDivider(
                          color: Colors.black,
                          width: 1,
                          indent: 15,
                          endIndent: 12,
                          thickness: 2,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              onlineCheck = false;
                              followingCheck = true;
                            });
                          },
                          onFocusChange: (val) {
                            onlineCheck = true;
                            followingCheck = false;
                          },
                          focusNode: following,
                          autofocus: followingCheck,
                          child: Text("Following",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: followingCheck
                                      ? Colors.pink
                                      : Colors.black)),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          "Find a Specialist",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.pushNamed(context, "doctorSearch");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future:
                          onlineCheck ? mongo.getDoctor() : mongo.getDoctor_2(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SizedBox(
                              width: w_s * 72.22,
                              height: h_s * 20.625,
                              child: const Center(
                                  child: SpinKitFadingCube(
                                color: Colors.pink,
                                size: 50.0,
                              )),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Flexible(
                            child: GridView.count(
                              crossAxisCount: 2,
                              children:
                                  List.generate(snapshot.data.length, (index) {
                                return docsAvailable(
                                    Appointment.fromJson(snapshot.data[index]));
                              }),
                            ),
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                              width: w_s * 72.22,
                              height: h_s * 20.625,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.wifi_off,
                                      color: Colors.pink),
                                  const SizedBox(height: 20),
                                  const Text("Network error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  MainButton(
                                    onPressed: () async {
                                      await mongo.getDoctor();
                                      // await mongo.getDoctor();
                                      if (!context.mounted)return;
                                        Navigator.restorablePushReplacementNamed(
                                                context, "doctorsAvailable");
                                    },
                                    color: Colors.pink,
                                    backgroundColor: Colors.pink,
                                    child: const Text("Refresh"),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      }),

                  //                 children: [
                  //                 DoctorsAvailableOnline(Name: "Esther \nObuobi", Speciality: "Cardiologist", picture: "doctor_1.jpg",
                  //  Experience: "6 Years", Patients: "890",  location: 'Korle Bu',),
                  //                 DoctorsAvailableOnline(Name: "Daniel \nAmissah", Speciality: "Psychiatric \nDoctor", picture: "doctor_2.jpg",
                  // Experience: "6 Years", Patients: "1.21K", location: 'KATH',),
                  //               DoctorsAvailableOnline(Name: "Freda Otu", Speciality: "Cardiologist", picture: "doctor_1.jpg",
                  // Experience: "2 Years", Patients: "3.21K", location: 'UCC Hospital', ),
                  //                   DoctorsAvailableOnline(Name: "Peter \nAtsu", Speciality: "Medicine \nSpecialist", picture: "doctor_2.jpg",
                  // Experience: "12 Years", Patients: "1.92K", location: 'KATH', ),
                  //                   DoctorsAvailableOnline(Name: "Priscilla \nSegbefia", Speciality: "Nuerologist", picture: "doctor_1.jpg",
                  // Experience: "9 Years", Patients: "3.91K", location: 'St. Helena Clinic', ),
                  //                   DoctorsAvailableOnline(Name: "Isaac \nAbanga", Speciality: "Pediatrician", picture: "doctor_2.jpg",
                  // Experience: "1 Year", Patients: "932", location: 'Ridge Hospital', ),
                  //               ],
                ])),
        bottomNavigationBar: BottomNavBar(
          idx: 1,
        ));
  }

  Widget docsAvailable(Appointment user) {
    return DoctorsAvailableOnline(
      name: "${user.fullname}",
      speciality: "${user.speciality}",
      picture: "${user.image}",
      experience: "${user.experience}",
      patients: "${user.patients}",
      location: '${user.location}',
      number: '${user.number}', email:"${user.email}",
    );
  }
// List<Widget> items_2=[
//   DoctorPick(Name: "Esther Obuobi", Speciality: "Cardiologist", picture: "doctor_1.jpg",
//     Experience: "6 Years", Patients: "890", rating: 4, location: 'Korle Bu',),
//   DoctorPick(Name: "Daniel Amissah", Speciality: "Psychiatric Doctor", picture: "doctor_2.jpg",
//     Experience: "6 Years", Patients: "1.21K",rating: 3, location: 'KATH',),
//   DoctorPick(Name: "Freda Otu", Speciality: "Cardiologist", picture: "doctor_1.jpg",
//     Experience: "2 Years", Patients: "3.21K",rating: 5, location: 'UCC Hospital', ),
//   DoctorPick(Name: "Peter Atsu", Speciality: "Medicine Specialist", picture: "doctor_2.jpg",
//     Experience: "12 Years", Patients: "1.92K",rating:2.8, location: 'KATH', ),
//   DoctorPick(Name: "Priscilla Segbefia", Speciality: "Nuerologist", picture: "doctor_1.jpg",
//     Experience: "9 Years", Patients: "3.91K",rating: 4.5, location: 'St. Helena Clinic', ),
//   DoctorPick(Name: "Isaac Abanga", Speciality: "Pediatrician", picture: "doctor_2.jpg",
//     Experience: "1 Year", Patients: "932",rating: 3.7, location: 'Ridge Hospital', ),
//
// ];
}
