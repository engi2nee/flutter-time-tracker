import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/app/home/models/Job.dart';
import 'package:time_tracker_flutter/app/services/ApiPath.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  @override
  Future<void> createJob(Job job) async => await _setData(
      data: job.toMap(),
      path: APIPath.job(
        uid,
        'job_abc',
      ));

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final refernce = Firestore.instance.document(path);
    print('$path: $data');
    await refernce.setData(data);
  }
}
