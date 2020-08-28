import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/app/home/models/Job.dart';
import 'package:time_tracker_flutter/app/services/ApiPath.dart';

import 'firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, documentIdFromCurrentDate()),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
