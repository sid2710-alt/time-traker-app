import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:traken/app/home/models/job.dart';
import 'package:traken/common_widgets/platform_alert_dialog.dart';
import 'package:traken/common_widgets/platform_exception_alert_dialog.dart';
import 'package:traken/services/database.dart';


class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database,this.job}) : super(key: key);
  final Database database;
  final Job job;


  static Future<void> show(BuildContext context,{Database database,Job job}) async {

    await Navigator.of(context,rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database,job: job,),
        fullscreenDialog: true,
      ),
    );
  }


  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  @override
  void initState() {
    if(widget.job!=null) {
      _name = widget.job.name;
    _ratePerHour=widget.job.ratePerHour;
    }
    super.initState();
  }
  final _formKey=GlobalKey<FormState>();
  bool _validateAndSaveForm()
  {
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      return true;}
    return false;

  }
  String _name;
  int _ratePerHour;
 Future<void> _submit() async{
if(_validateAndSaveForm())
  {
    try {
      final jobs=await widget.database.jobsStream().first;
      final allNames=jobs.map((job) =>job.name ).toList();
      if(widget.job!=null)
        {
          allNames.remove(widget.job.name);
        }
      if(allNames.contains(_name))
        {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different name',
            defaultActionText: 'OK',
          ).show(context);
        }
      else {
        final id=widget.job?.id??documentIdFromCurrentDate();
        final job = Job(name: _name, ratePerHour: _ratePerHour,id: id);
        await widget.database.setJob(job);
        Navigator.of(context).pop();
      } }on PlatformException catch (e) {
   PlatformExceptionAlertDialog(
   title: 'Operation Failed',
   exception: e,
   ).show(context);
   }
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job==null?'New Job':'Edit Job'),
        actions: [
          TextButton(onPressed: _submit, child: Text(
            'Save',style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
          ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey,
    );
  }

Widget  _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:_buildForm(),
          ),
        ),
      ),
    );
}

 Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(),
      ),
    );
 }

 List<Widget> _buildFormChildren() {
    return[
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        initialValue: _name,
        validator: (value)=>value.isNotEmpty? null:'Job name cant be empty',
        onSaved: (value)=> _name=value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
        initialValue: _ratePerHour!=null?'$_ratePerHour':null,
        onSaved: (value)=> _ratePerHour=int.tryParse(value)??0,
      ),
    ];
 }
}
