import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:traken/app/home/job_entries/job_entries_page.dart';
import 'package:traken/app/home/jobs/add_job_page.dart';
import 'package:traken/app/home/jobs/add_job_tile.dart';
import 'package:traken/app/home/jobs/list_items_builder.dart';
import 'package:traken/app/home/models/job.dart';
import 'package:traken/common_widgets/platform_exception_alert_dialog.dart';
import 'package:traken/services/database.dart';

class JobsPage extends StatelessWidget {




  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => EditJobPage.show(context,
                database: Provider.of<Database>(context, listen: false)),
          ),

        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}

//if (snapshot.hasData) {

//final jobs = snapshot.data;
//(jobs.isNotEmpty){
//final children = jobs.map((job) => JobListTile(job: job,onTap:()=>AddJobPage.show(context,job: job),)).toList();
//  return ListView(children: children);
//}
//return EmptyContent();
//}
//if (snapshot.hasError) {
//return Center(child: Text('Some error occurred'));
//}
//return Center(child: CircularProgressIndicator());
//},
//);
//}

//}
