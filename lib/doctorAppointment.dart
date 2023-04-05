import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:project/MainButton.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/main.dart';
import 'package:project/mongo.dart';
import 'package:project/user.dart';
import 'package:time_slot/controller/day_part_controller.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';

class DoctorAppointment extends StatefulWidget {
  final String name;
  final String speciality;
  final String patients;
  final String location;
  final String number;
  const DoctorAppointment({
    Key? key,
    required this.name,
    required this.speciality,
    required this.patients,
    required this.location,
    required this.number,
  }) : super(key: key);

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();
  DayPartController dayPartController = DayPartController();
  DateTime date = DateTime.now().add(const Duration(hours: 24));
  late var formattedDate;
  String dateGet = "";
  bool dateConfirm = false;
  bool timeSlot = false;
  var selectTime = DateTime.now();
  bool loading = false;
  @override
  void initState() {
    print(widget.name);
    formattedDate = DateFormat('d-MMM-yy').format(date);
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: SpinKitFadingCube(
                color: Colors.pink,
                size: 50.0,
              ))
            : Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_outlined),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            Text("Appointment",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("")
                          ]),
                      SizedBox(height: h_s * 6.25),
                      Expanded(
                        child: ListView(
                          children: [
                            SecondaryButton(
                                child: Text("Select Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                onPressed: () async {
                                  print("datepick");
                                  print(date.weekday);
                                  await showDatePicker(
                                    context: context,
                                    selectableDayPredicate:
                                        (DateTime weekdays) =>
                                            (weekdays.weekday == 6 ||
                                                    weekdays.weekday == 7)
                                                ? false
                                                : true,
                                    helpText: "SELECT DATE FOR APPOINTMENT",
                                    confirmText: "CONFIRM",
                                    initialDate:
                                        date.weekday == 6 || date.weekday == 7
                                            ? DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 3)
                                            : date,
                                    firstDate: date,
                                    lastDate: DateTime.utc(
                                        DateTime.now().year + 1, 12, 31),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      setState(() {
                                        date = selectedDate;
                                        formattedDate = DateFormat('d-MMM-yy')
                                            .format(selectedDate);
                                        timeSlot = true;
                                        dateGet = DateFormat('d-MMM-yy')
                                            .format(selectedDate);
                                      });
                                    }
                                  });
                                },
                                color: Colors.pink,
                                backgroundColor: Colors.pink),
                            SizedBox(height: h_s * 6.25),
                            Text("$dateGet"),
                            SizedBox(height: h_s * 2.5),
                            Text("Slots"),
                            Visibility(
                              visible: timeSlot,
                              child: TimesSlotGridViewFromInterval(
                                locale: "en",
                                initTime: selectTime,
                                crossAxisCount: 4,
                                timeSlotInterval: const TimeSlotInterval(
                                  start: TimeOfDay(hour: 8, minute: 00),
                                  end: TimeOfDay(hour: 16, minute: 0),
                                  interval: Duration(hours: 1, minutes: 0),
                                ),
                                onChange: (value) {
                                  setState(() {
                                    selectTime = value;
                                    dateConfirm = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SecondaryButton(
                        onPressed: !dateConfirm
                            ? null
                            : () async {
                                setState(() {
                                  loading = true;
                                });
                                var appointment = Appointment(
                                    date: dateGet,
                                    time:
                                        "${selectTime.hour.toString()}:${selectTime.minute.toString()}0",
                                    doctor: "${widget.name}",
                                    speciality: "${widget.speciality}",
                                    location: "${widget.location}",
                                    number: "${widget.number}");
                                await mongo.insertAppointmentDetail(
                                    appoint: appointment);
                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Successfully booked appointment")));
                                Navigator.restorablePushReplacementNamed(
                                    context, "homepage");
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                //     Appointments(date: date, time:
                                //     "${selectTime.hour.toString()}"+":${selectTime.minute.toString()}0",
                                //   doctorName: '${widget.name}', speciality: '${widget.speciality}',
                                // location: "${widget.location}",)
                                // ));
                              },
                        color: Colors.amberAccent,
                        backgroundColor: Colors.amberAccent,
                        child: Text("Confirm Appointment"),
                      ),
                      SizedBox(height: 10)
                    ]),
              ),
      ),
    );
  }
}
