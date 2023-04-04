import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import 'package:project/user.dart';
import 'package:project/userProvider.dart';

const url =
    "mongodb+srv://jerrito0240:streak0240845898@cluster0.5dpfja6.mongodb.net/ayaresapa?retryWrites=true&w=majority";
const collection = "ayaresapaAccount";
const collectionAppointment = "ayaresapaAppointment";

class mongo {
  static var db, doctorCollection, appointmentCollection;
  static con() async {
    db = await Db.create(url);
    await db.open();
    // Db.inspect(db);
    doctorCollection = db.collection(collection);
    appointmentCollection = db.collection(collectionAppointment);
  }

  static Future<List<Map<String, dynamic>>> getDoctor() async {
    await mongo.con();
    var findDoc = await doctorCollection.find().toList();
    return findDoc;
  }

  static Future<List<Map<String, dynamic>>> getDoctorOnline() async {
    await mongo.con();
    var findDoc = await doctorCollection.find(where.eq("live", 1)).toList();
    return findDoc;
  }

  static Future<List<Map<String, dynamic>>> getDoctorByCategory(
      String name, dynamic val) async {
    await mongo.con();
    var findDoc = await doctorCollection.find(where.eq(name, val)).toList();
    return findDoc;
  }

  static Future<List<Map<String, dynamic>>> getDoctorBySearch(
      dynamic val) async {
    await mongo.con();
    var findDoc =
        await doctorCollection.find(where.match("fullname", val)).toList();
    return findDoc;
  }

  static Stream<Future<List<Map<String, dynamic>>>> getDoctorBySearchStream(
      dynamic val) {
    mongo.con();
    var findDoc = doctorCollection.find(where.eq("fullname", val)).toList();
    return findDoc;
  }

  static Future<List<Map<String, dynamic>>> getDoctor_2() async {
    mongo.con();
    var findDoc = await doctorCollection
        .find(where.eq("speciality", "Family physician"))
        .toList();
    return findDoc;
  }

  static Future<List<Map<String, dynamic>>> getAppointment() async {
    var findDoc = await appointmentCollection.find().toList();
    return findDoc;
  }

  static Future deleteAppointment(String name, dynamic val) async {
    var findDoc = await appointmentCollection.deleteOne(where.eq(name, val));
    return findDoc;
  }

  static Future<String> insertAppointmentDetail(
      {required Appointment appoint}) async {
    try {
      var result = await appointmentCollection.insertOne(appoint.toJson());
      if (result.success) {
        // ScaffoldMessenger.;
        return "success";
      } else {
        return "failed";
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
