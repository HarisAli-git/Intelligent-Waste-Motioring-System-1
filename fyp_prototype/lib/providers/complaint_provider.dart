import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp_prototype/models/complaint.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vector_math/vector_math.dart' as vectorMath;
import 'dart:math' as math;

class ComplaintProvider {
  Function getUserId = () {};
  final FirebaseDatabase _firebaseDatabase;

  ComplaintProvider(this._firebaseDatabase, this.getUserId);

  Future<String> registerComplaint(Complaint complaint) async {
    try {
      /**
       * If the user has submitted a complaint 10 mins ago and 
       * the complaint is in the 10 meter raduis than decalre it as the same
       * complaint and no need to spam/submit it
       */
      /*DatabaseEvent event = await _firebaseDatabase.ref('complaints').once();
      List<dynamic> complaintsList = [];
      final userId = await getUserId();
      for (var element in event.snapshot.children) {
        complaintsList.add(element.value);
      }

      for (var element in complaintsList) {
        if (element['uid'] != userId) {
          complaintsList.remove(element);
        }
      }

      if (complaintsList.isNotEmpty) {
        DateTime latestDate = DateTime.parse(complaintsList[0]['dateTime']);
        for (int i = 1; i < complaintsList.length; i++) {
          if (latestDate
              .isBefore(DateTime.parse(complaintsList[i]['dateTime']))) {
            latestDate = DateTime.parse(complaintsList[i]['dateTime']);
          }
        }
      }
      DateTime date1 = DateTime.parse(complaint.getDateTime.toString());
      if (complaintsList.isNotEmpty) {
        if (complaintsList[0]['uid'] == userId &&
            complaintsList[0]['status'] == 'Registered') {
          DateTime date2 = DateTime.parse(complaintsList[0]['dateTime']);
          if (minutesBetween(date1, date2) < 10) {
            print('between: ' + minutesBetween(date1, date2).toString());
            if (distance(
                    complaintsList[0]['latitude'],
                    complaintsList[0]['longitude'],
                    complaint.getLatitude,
                    complaint.getLongitude) >
                10) {
              print('distance: ' +
                  distance(
                          complaintsList[0]['latitude'],
                          complaintsList[0]['longitude'],
                          complaint.getLatitude,
                          complaint.getLongitude)
                      .toString());
              var data = {
                'uid': complaint.getUserId,
                'longitude': complaint.getLongitude,
                'latitude': complaint.getLatitude,
                'status': complaint.getStatus,
                'dateTime': complaint.getDateTime.toString(),
                'imageUrl':
                    complaint.getImageUrl == '' ? '' : complaint.getImageUrl,
              };
              final _firebaseStorage = FirebaseStorage.instanceFor(
                  bucket: "gs://fyp-project-98f0f.appspot.com");
              var file = File(complaint.imageFile.path);

              final longitude = data['longitude'];
              final latitude = data['latitude'];
              final uid = data['uid'];
              final time = data['dateTime'].toString();

              var snapshot = await _firebaseStorage
                  .ref()
                  .child('images/$longitude$latitude$uid$time')
                  .putFile(file);

              await snapshot.ref.getDownloadURL().then((value) async {
                data['imageUrl'] = value;
                await _firebaseDatabase
                    .ref()
                    .child("complaints")
                    .push()
                    .set(data);
              });
              print('Complaint Registered minutes < 10 distance > 10!');
              return "Complaint Registered!";
            } else {
              print('between: ' + minutesBetween(date1, date2).toString());
              print('distance: ' +
                  distance(
                          complaintsList[0]['latitude'],
                          complaintsList[0]['longitude'],
                          complaint.getLatitude,
                          complaint.getLongitude)
                      .toString());
              print('Same Location!');
              return 'Same location';
            }
          } else {
            //IF the minutes are greater than 10
            var data = {
              'uid': complaint.getUserId,
              'longitude': complaint.getLongitude,
              'latitude': complaint.getLatitude,
              'status': complaint.getStatus,
              'dateTime': complaint.getDateTime.toString(),
              'imageUrl':
                  complaint.getImageUrl == '' ? '' : complaint.getImageUrl,
            };
            final _firebaseStorage = FirebaseStorage.instanceFor(
                bucket: "gs://fyp-project-98f0f.appspot.com");
            var file = File(complaint.imageFile.path);

            final longitude = data['longitude'];
            final latitude = data['latitude'];
            final uid = data['uid'];
            final time = data['dateTime'].toString();

            var snapshot = await _firebaseStorage
                .ref()
                .child('images/$longitude$latitude$uid$time')
                .putFile(file);

            await snapshot.ref.getDownloadURL().then((value) async {
              data['imageUrl'] = value;
              await _firebaseDatabase
                  .ref()
                  .child("complaints")
                  .push()
                  .set(data);
            });
            print('Complaint Registered minutes > 10!');
            return "Complaint Registered!";
          }
        }
      } else {
        var data = {
          'uid': complaint.getUserId,
          'longitude': complaint.getLongitude,
          'latitude': complaint.getLatitude,
          'status': complaint.getStatus,
          'dateTime': complaint.getDateTime.toString(),
          'imageUrl': complaint.getImageUrl == '' ? '' : complaint.getImageUrl,
        };
        final _firebaseStorage = FirebaseStorage.instanceFor(
            bucket: "gs://fyp-project-98f0f.appspot.com");
        var file = File(complaint.imageFile.path);

        final longitude = data['longitude'];
        final latitude = data['latitude'];
        final uid = data['uid'];
        final time = data['dateTime'].toString();

        var snapshot = await _firebaseStorage
            .ref()
            .child('images/$longitude$latitude$uid$time')
            .putFile(file);

        await snapshot.ref.getDownloadURL().then((value) async {
          data['imageUrl'] = value;
          await _firebaseDatabase.ref().child("complaints").push().set(data);
        });
        print('Complaint Registered complaintsList == null!');
        return "Complaint Registered!";
      }*/

      var data = {
        'uid': complaint.getUserId,
        'longitude': complaint.getLongitude,
        'latitude': complaint.getLatitude,
        'status': complaint.getStatus,
        'dateTime': complaint.getDateTime.toString(),
        'imageUrl': complaint.getImageUrl == '' ? '' : complaint.getImageUrl,
      };
      final _firebaseStorage = FirebaseStorage.instanceFor(
          bucket: "gs://fyp-project-98f0f.appspot.com");
      var file = File(complaint.imageFile.path);

      final longitude = data['longitude'];
      final latitude = data['latitude'];
      final uid = data['uid'];
      final time = data['dateTime'].toString();

      var snapshot = await _firebaseStorage
          .ref()
          .child('images/$longitude$latitude$uid$time')
          .putFile(file);

      await snapshot.ref.getDownloadURL().then((value) async {
        data['imageUrl'] = value;
        await _firebaseDatabase.ref().child("complaints").push().set(data);
      });

      return 'Registered!';
    } catch (e) {
      print('Error: $e');
      return e.toString();
    }
  }

  Future<List<dynamic>> getAllComplaint() async {
    try {
      DatabaseEvent event = await _firebaseDatabase.ref('complaints').once();
      List<dynamic> res = [];
      for (var element in event.snapshot.children) {
        res.add(element.value);
      }
      return res;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<dynamic>> FilterComplaintsByUserId() async {
    try {
      List<dynamic> complaintsList = await getAllComplaint();
      List<dynamic> filteredList = [];
      final userId = await getUserId();
      for (var complaint in complaintsList) {
        if (complaint['uid'] == userId) {
          filteredList.add(complaint);
        }
      }
      return filteredList;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  double distance(double lat1, double long1, double lat2, double long2) {
    // Convert the latitudes
    // and longitudes
    // from degree to radians.
    lat1 = vectorMath.radians(lat1);
    long1 = vectorMath.radians(long1);
    lat2 = vectorMath.radians(lat2);
    long2 = vectorMath.radians(long2);

    // Haversine Formula
    double dlong = long2 - long1;
    double dlat = lat2 - lat1;

    double ans = math.pow(math.sin(dlat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dlong / 2), 2);

    ans = 2 * math.asin(math.sqrt(ans));

    // Radius of Earth in
    // Kilometers, R = 6371
    // Use R = 3956 for miles
    //double R = 6371;
    double R = (1.56786 * math.pow(math.e, -7));

    // Calculate the result in meters
    ans = ans * R;

    return ans;
  }

  int minutesBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    print('from:' + from.toString());
    print('to:' + to.toString());
    return (from.difference(to).inMinutes).round();
  }
}
