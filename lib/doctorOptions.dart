import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/MainButton.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/doctorAppointment.dart';
import 'package:project/main.dart';
import 'package:project/role.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;



class DoctorOptions extends StatefulWidget {
  final String name;
  final String speciality;
  final String pic;
  final String number;
  final String patients;
  final String experience;
  final String email;
  final String follow;
  final String location;
  const DoctorOptions(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.pic,
      required this.patients,
      required this.experience,
      required this.email,
      required this.follow,
      required this.location,
      required this.number})
      : super(key: key);

  @override
  State<DoctorOptions> createState() => _DoctorOptionsState();
}

class _DoctorOptionsState extends State<DoctorOptions> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  icon: Platform.isIOS
                      ? const Icon(Icons.arrow_back_ios_new_outlined)
                      : const Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Text("Dr. ${widget.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Text("")
            ]),
            Flexible(
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    height: h_s * 37.5,
                    color: const Color.fromRGBO(210, 230, 250, 0.2),
                    child: Center(
                        child: Image.network(widget.pic,
                            width: double.infinity, height: 300)),
                  ),
                  SizedBox(height: h_s * 2.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: w_s * 30.56,
                          height: h_s * 6.25,
                          child: IconLabelButton(
                              label: "Voice call",
                              icon:
                                  const Icon(Icons.phone, color: Colors.white),
                              onPressed: () {
                                urlLauncher.launchUrl(
                                    Uri(scheme: "tel", host: widget.number));
                              },
                              backgroundColor: Colors.lightGreen,
                              color: Colors.lightGreen)),
                      SizedBox(
                          width: w_s * 30.56,
                          height: h_s * 6.25,
                          child: IconLabelButton(
                              label: "Video call",
                              icon: const Icon(Icons.video_call_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                 context,
                                  MaterialPageRoute(builder:
                                  ( BuildContext context)=>
                                      const VideoCallStartPage(

                                  )
                                  )
                                );
                              },
                              backgroundColor: Colors.purple,
                              color: Colors.purple)),
                      SizedBox(
                          width: w_s * 30.56,
                          height: h_s * 6.25,
                          child: IconLabelButton(
                              label: "Email",
                              icon: const Icon(Icons.email_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                //print(widget.email);
                                urlLauncher.launchUrl(
                                    Uri(scheme: "mailto", path: widget.email));
                              },
                              backgroundColor: Colors.orange,
                              color: Colors.orange)),
                      // SizedBox(width: 100, child: MainButton(child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.video_call_outlined), label: Text("Video Call")), onPressed: (){}, color: Colors.blue)),
                      //SizedBox(width: 100, child: MainButton(child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.phone), label: Text("")), onPressed: (){}, color: Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.speciality,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.location,
                          style: const TextStyle(fontSize: 16))),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("About ${widget.name}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, ")),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          const Text("Patients"),
                          Text(widget.patients,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ]),
                        Column(children: [
                          const Text("Experience"),
                          Text(widget.experience,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ]),
                        Column(children: const [
                          Text("Reviews"),
                          Text("2.54K",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ])
                      ]),
                  const SizedBox(height: 20),
                  SecondaryButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorAppointment(
                                  name: widget.name,
                                  speciality: widget.speciality,
                                  patients: widget.patients,
                                  location: widget.location,
                                  number: widget.number)));
                    },
                    color: Colors.pink,
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    child: const Text("Book an Appointment"),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
