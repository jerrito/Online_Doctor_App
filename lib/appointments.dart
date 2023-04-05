import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/MainButton.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/bottomNavigation.dart';
import 'package:project/main.dart';
import 'package:project/mongo.dart';
import 'package:project/user.dart';

class Appointments extends StatefulWidget {
  final DateTime date;
  final String time;
  final String doctorName;
  final String speciality;
  final String location;
  const Appointments({
    Key? key,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.speciality,
    required this.location,
  }) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();

  // didUpdateWidget() {
  //   setState(() {
  //     indexed = 0;
  //   });
  // }
  @override
  void initState() {
    super.initState();
  }

  // Future<void> nas()async {
  //    setState(() {
  //      indexed = 0;
  //    });
  //  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   setState(() {
  //     indexed = 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(10),
            color: const Color.fromRGBO(210, 230, 250, 0.2),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Center(
                child: Text("Appointment",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),

              SizedBox(height: h_s * 2.5),
              FutureBuilder(
                  future: mongo.getAppointment(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var appointmentList = snapshot.data.length;
                      return Flexible(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return appointListGet(
                                Appointment.fromJson(snapshot.data[index]));
                          },
                          itemCount: appointmentList,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 200.0),
                        child: Center(
                            child: SpinKitFadingCube(
                          color: Colors.pink,
                          size: 50.0,
                        )),
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                          width: w_s * 72.22,
                          height: h_s * 20.625,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.wifi_off, color: Colors.pink),
                              const SizedBox(height: 10),
                              const Text("Network error",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              MainButton(
                                onPressed: () async {
                                  await mongo.con();
                                  // await mongo.getDoctor();
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
                  }),
              // Flexible(
              //   child: ListView(
              //     children: [
              //
              //       SizedBox(height:h_s*2.5),
              //       AppointmentList(date:widget.date, time: widget.time, doctorName: widget.doctorName,
              //         speciality: widget.speciality,location: widget.location,),
              //       SizedBox(height:h_s*2.5),
              //       AppointmentList(date:widget.date.toUtc(), time: '${widget.time}',location:'${widget.location}' ,
              //         doctorName: widget.doctorName, speciality: '${widget.speciality}',),
              //       SizedBox(height:h_s*2.5),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}',location: '${widget.location}',),
              //        SizedBox(height:h_s*2.5),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}',location: '${widget.location}',),
              //       SizedBox(height:h_s*2.5),
              //       AppointmentList(date:widget.date, time: '${widget.time}',
              //         doctorName: '${widget.doctorName}', speciality: '${widget.speciality}', location: '${widget.location}',),
              //     ],),
              // ),
            ]),
          ),
          bottomNavigationBar: BottomNavBar(
            idx: 2,
          )),
    );
  }

  Widget appointListGet(Appointment appoint) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: AppointmentList(
          date: "${appoint.date}",
          time: "${appoint.time}",
          doctorName: "${appoint.doctor}",
          speciality: "${appoint.speciality}",
          location: "${appoint.location}"),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final String date;
  final String time;
  final String doctorName;
  final String speciality;
  final String location;
  const AppointmentList(
      {Key? key,
      required this.date,
      required this.time,
      required this.doctorName,
      required this.speciality,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: h_s * 13.75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: [
              Text("Date\n$date",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              // RichText(text: TextSpan(text:"Speciality", children:  <TextSpan>[TextSpan(text: '\n$speciality', style: TextStyle(fontWeight:FontWeight.bold,fontSize:16)),],)),
              Text(
                  speciality.length >= 13
                      ? "Speciality\n${speciality.substring(0, 12)}..."
                      : "Speciality\n$speciality",
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          Column(
            children: [
              Text("Time\n$time",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              Text(
                  location.length >= 15
                      ? "Location\n${location.substring(0, 14)}..."
                      : "Location\n$location",
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          Column(
            children: [
              Text(
                  doctorName.length >= 15
                      ? "Doctor\nDr. ${doctorName.substring(0, 14)}..."
                      : "Doctor\nDr. $doctorName",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                width: 100,
                child: MainButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (
                          BuildContext context,
                        ) {
                          return SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.black54,
                              children: [
                                const Text(
                                    "Do you want to proceed with your cancellation of appointment?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () async {
                                            await mongo.deleteAppointment(
                                                "date", date);
                                            if (!context.mounted) return;
                                            Navigator
                                                .restorablePushReplacementNamed(
                                                    context, "appoinments");
                                          },
                                          child: const Text("Yes"))
                                    ])
                              ]);
                        });

                    //  print(date);
                  },
                  color: Colors.redAccent,
                  backgroundColor: Colors.redAccent,
                  child: const Text("Cancel"),
                ),
              ),
            ],
          )
        ]));
  }
}
