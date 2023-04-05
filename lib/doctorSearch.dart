import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/MainButton.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/homeContainers.dart';
import 'package:project/main.dart';
import 'package:project/mongo.dart';
import 'package:project/user.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({
    Key? key,
    required this.cardvalue,
  }) : super(key: key);
  final String cardvalue;
  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();
  bool cardSelection = true;

  String cardvalue = "Family physician";
  int i = 0;
  var doctorTypes = [
    "Obstetrician",
    "Gynecologist",
    "Neurologist",
    "Radiologist",
    "Dentist",
    "Anesthesiologist",
    "Family physician",
    "Psychiatrist",
    "Internist",
    "Pediatrician",
    "Dermatologist",
    "Ophthalmologist",
    "E.R doctor"
  ];
  @override
  void initState() {
    setState(() {
      cardvalue = widget.cardvalue;
      i = 20;
    });
    //print(cardvalue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromRGBO(210, 230, 250, 0.2),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  icon: Platform.isMacOS
                      ? const Icon(Icons.arrow_back_ios_new_outlined)
                      : const Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              const Text("Search Here",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text("")
            ]),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Search Your",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Specialist",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 20),
            // MainInput(obscureText: false)
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Area",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            Container(
              height: h_s * 7.25, width: w - 20, //alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.black, width: 1, style: BorderStyle.solid)),
              child: DropdownButton(
                  value: cardvalue,
                  key: dropdownKey,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: doctorTypes.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      onTap: () {
                        // cardvalue = value!;
                        // idType=cardvalue;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SizedBox(width: SizeConfig.blockSizeHorizontal*5.56,),
                          Text(items,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: (w - 20) - 168,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    setState(() {
                      cardvalue = newValue!;
                      i = 20;
                    });
                  }),
            ),
            SizedBox(height: h_s * 6.25),
            FutureBuilder(
              future: mongo.getDoctorByCategory(
                "speciality",
                cardvalue,
              ),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return docArea(
                              Appointment.fromJson(snapshot.data[index]));
                        }),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: SpinKitFadingCube(
                    color: Colors.pink,
                    size: 50.0,
                  ));
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off, color: Colors.pink),
                          const SizedBox(height: 20),
                          const Text("Network error",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          MainButton(
                            onPressed: () async {
                              await mongo.getDoctor();
                              if (!context.mounted) return;
                              Navigator.restorablePushReplacementNamed(
                                  context, "homepage");
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
              },
            ),
            // DoctorArea(Name: 'Serena Gomez', Speciality: 'Cardiologist',
            //   picture: 'doctor_1.jpg', location: 'UCC Hospital',)
          ]),
        ),
      ),
    );
  }

  Widget docArea(Appointment user) {
    return DoctorArea(
      name: '${user.fullname}',
      speciality: '${user.speciality}',
      picture: '${user.image}',
      location: '${user.location}',
      number: '${user.number}',
    );
  }
}
