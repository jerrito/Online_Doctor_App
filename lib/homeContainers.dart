import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/Size_of_screen.dart';
import 'package:project/doctorOptions.dart';
import 'package:project/doctorSearch.dart';
import 'package:project/main.dart';

class DoctorInfo extends StatelessWidget {
  final String name;
  final String speciality;
  final String location;
  final String picture;
  final String number;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String experience;
  final String patients;

  const DoctorInfo(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.location,
      required this.picture,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.experience,
      required this.patients,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorOptions(
                    name: name,
                    speciality: speciality,
                    pic: picture,
                    patients: patients,
                    experience: experience,
                    follow: '1.53K',
                    location: location,
                    number: number)));
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
          width: w_s * 72.22,
          height: h_s * 20.625,
          decoration: BoxDecoration(
              color: Colors.pink, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              VerticalDivider(
                width: 1,
                indent: h_s * 10,
                endIndent: h_s * 3.75,
                thickness: 2,
                color: Colors.white,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Looking For Your Desire\nSpecialist Doctor?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  //  Text("Specialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                  SizedBox(height: h_s * 5),
                  // VerticalDivider(width: 1,indent: 80,endIndent:20,thickness: 2,color: Colors.white,),
                  Text(
                      name.length >= 20
                          ? "${name.substring(0, 17) + "..."}"
                          : "Dr. $name",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Text(speciality,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white)),
                  Text(
                      location.length >= 20
                          ? "${location.substring(0, 17) + "..."}"
                          : location,
                      style: const TextStyle(fontSize: 14, color: Colors.white))
                ],
              ),
              SizedBox(
                  width: w_s * 13.89,
                  height: h_s * 13.75,
                  child: FadeInImage.assetNetwork(
                      width: w_s * 13.89,
                      height: h_s * 13.75,
                      fit: BoxFit.fill,
                      // imageCacheHeight: 110,imageCacheWidth: 50,
                      // placeholderCacheHeight:110 ,placeholderCacheWidth:50 ,
                      placeholder: './assets/images/docmain.png',
                      image: picture,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('./assets/images/docmain.png',
                            fit: BoxFit.fill);
                      })
                  //Image.network("$picture",fit: BoxFit.fill,width: 50,height:110)
                  )
            ],
          )),
    );
  }
}

class DoctorCategories extends StatelessWidget {
  final IconData icon;
  final String role;
  final void Function()? onTap;
  const DoctorCategories(
      {Key? key, required this.icon, required this.role, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return DoctorSearch(
            cardvalue: role,
          );
        }));
      },
      child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: w_s * 27.78,
          height: h_s * 12.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.pink),
            const SizedBox(height: 10),
            Text(role.length >= 20 ? "${role.substring(0, 17) + "..."}" : role,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
          ])),
    );
  }
}

class DoctorPick extends StatelessWidget {
  final String name;
  final String speciality;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String experience;
  final String patients;
  final double rating;
  final String picture;
  final String location;
  final String number;
  const DoctorPick(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.picture,
      required this.experience,
      required this.patients,
      required this.rating,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.location,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorOptions(
                      name: name,
                      speciality: speciality,
                      pic: picture,
                      patients: patients,
                      experience: experience,
                      follow: '1.53K',
                      location: location,
                      number: number,
                    )));
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
          width: w_s * 72.22,
          height: h_s * 23.125,
          padding: const EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //VerticalDivider(width: 1,indent: 80,endIndent:30,thickness: 2,color: Colors.white,),
              SizedBox(
                width: w_s * 50.56,
                height: h_s * 23.125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text("Looking For Your Desire\nSpecialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                    //  Text("Specialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                    // VerticalDivider(width: 1,indent: 80,endIndent:20,thickness: 2,color: Colors.white,),
                    Text(
                        name.length >= 20
                            ? "Dr ${name.substring(0, 19) + "..."}"
                            : "Dr. $name",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Text(speciality,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black)),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // print(rating);
                      },
                    ),
                    const SizedBox(height: 7),
                    Text("Experience: $experience year(s)",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black)),
                    const SizedBox(height: 10),
                    Text("Patients  \n$patients",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black))
                  ],
                ),
              ),
              SizedBox(
                  width: w_s * 16.67,
                  height: h_s * 17.5,
                  child: FadeInImage.assetNetwork(
                      width: w_s * 16.67,
                      height: h_s * 17.5,
                      fit: BoxFit.fill,
                      // imageCacheHeight: 140,imageCacheWidth: 50,
                      //  placeholderCacheHeight:140 ,placeholderCacheWidth:50 ,
                      placeholder: './assets/images/doctor_1.jpg',
                      image: picture,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('./assets/images/docmain.png',
                            fit: BoxFit.fill);
                      }))
              //Image.network("$picture",fit: BoxFit.fill,width: 50,height:140))
            ],
          )),
    );
  }
}

class DoctorsAvailableOnline extends StatelessWidget {
  final String name;
  final String speciality;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String experience;
  final String patients;
  final String number;
  final String picture;
  final String location;
  const DoctorsAvailableOnline(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.picture,
      required this.experience,
      required this.patients,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.location,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorOptions(
                      name: name,
                      speciality: speciality,
                      pic: picture,
                      patients: patients,
                      experience: experience,
                      follow: '1.53K',
                      location: location,
                      number: number,
                    )));
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
          width: w_s * 41.67,
          height: h_s * 23.75,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(right: 2, left: 2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //VerticalDivider(width: 1,indent: 80,endIndent:30,thickness: 2,color: Colors.white,),
              SizedBox(
                width: w_s * 25.78,
                height: h_s * 23.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text("Looking For Your Desire\nSpecialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                    //  Text("Specialist Doctor?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.white)),
                    // VerticalDivider(width: 1,indent: 80,endIndent:20,thickness: 2,color: Colors.white,),
                    Text(
                        name.length >= 15
                            ? "Dr ${name.substring(0, 14) + "..."}"
                            : "Dr. $name",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Text(speciality,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                    const SizedBox(height: 4),
                    Text("Experience\n$experience",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                    const SizedBox(height: 4),
                    Text("Patients\n$patients",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black))
                  ],
                ),
              ),
              SizedBox(
                  width: w_s * 12.89,
                  height: h_s * 12.5,
                  child:
                      //Image.network("$picture",
                      //     fit: BoxFit.fill,
                      //     width: w_s * 12.89,
                      //     height: h_s * 12.5)
                      FadeInImage.assetNetwork(
                    fit: BoxFit.fill,
                    width: w_s * 12.89,
                    height: h_s * 12.5,
                    placeholder: './assets/images/docmain.png',
                    image: picture,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('./assets/images/docmain.png',
                          fit: BoxFit.fill);
                    },
                    // fit: BoxFit.fitWidth,
                  )),
            ],
          )),
    );
  }
}

class DoctorArea extends StatelessWidget {
  final String name;
  final String speciality;
  final String number;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final String picture;
  final String location;
  const DoctorArea(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.picture,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.location,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorOptions(
                      name: name,
                      speciality: speciality,
                      pic: picture,
                      patients: "755",
                      experience: "3 Years",
                      follow: '1.53K',
                      location: location,
                      number: number,
                    )));
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
          width: double.infinity, //height: 100,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            minLeadingWidth: 10.0,
            minVerticalPadding: 5.0,
            horizontalTitleGap: 40,
            leading: SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundImage:
                    Image.network(picture, fit: BoxFit.cover).image,
              ),
            ),
            title: Text("Dr. $name",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            subtitle: Text("$speciality\n\n$location",
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            //Text("$location",style:TextStyle(fontSize:12,color:Colors.black)),
          )),
    );
  }
}

class DoctorSearcher extends StatelessWidget {
  final String name;
  final String speciality;
  final String number;
  final String image;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  final String location;
  const DoctorSearcher(
      {Key? key,
      required this.name,
      required this.speciality,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.location,
      required this.number,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorOptions(
                      name: name,
                      speciality: speciality,
                      pic: image,
                      patients: "755",
                      experience: "3 Years",
                      follow: '1.53K',
                      location: location,
                      number: number,
                    )));
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
          width: double.infinity, //height: 100,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            minLeadingWidth: 10.0,
            minVerticalPadding: 5.0,
            horizontalTitleGap: 40,
            leading: SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundImage: Image.network(image).image,
              ),
            ),
            title: Text("Dr. $name",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            subtitle: Text("$speciality\n\n$location",
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            //Text("$location",style:TextStyle(fontSize:12,color:Colors.black)),
          )),
    );
  }
}
