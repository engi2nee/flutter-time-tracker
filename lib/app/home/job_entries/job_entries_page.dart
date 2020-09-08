import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_flutter/app/home/job_entries/entry_page.dart';
import 'package:time_tracker_flutter/app/home/jobs/EditJobPage.dart';
import 'package:time_tracker_flutter/app/home/jobs/ListItemBuilder.dart';
import 'package:time_tracker_flutter/app/home/models/Entry.dart';
import 'package:time_tracker_flutter/app/home/models/Job.dart';
import 'package:time_tracker_flutter/app/services/Database.dart';
import 'package:time_tracker_flutter/widgets/PlatformExceptionAlertDialog.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});

  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(job.name),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () =>
                EditJobPage.show(context, job: job, database: database),
          ),
        ],
      ),
      body: _buildContent(context, job),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            EntryPage.show(context: context, database: database, job: job),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
