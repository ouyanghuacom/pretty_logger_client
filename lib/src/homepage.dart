import 'package:flutter/material.dart';
import 'mdns_service/mdns_service.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

enum _Status { none, doing, done }

class _HomepageState extends State<Homepage> {
  _Status _status;
  @override
  void initState() {
    super.initState();
    _status = _Status.none;
  }

  void onPressed(BuildContext context) {
    if (_status == _Status.doing) return;
    if (_status == _Status.none) {
      setState(() => _status = _Status.doing);
      MdnsService.start('_pretty_logger_client._tcp', 34567).then(
        (value) {
          if (null == value) {
            setState(() => _status = _Status.done);
            return;
          }
          showDialog(
            context: context,
            child: AlertDialog(
              content: Text(value),
              actions: [
                FlatButton(
                  child: Text('GOT IT'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
          setState(() => _status = _Status.none);
        },
      );
      return;
    }

    if (_status == _Status.done) {
      setState(() => _status = _Status.doing);
      MdnsService.stop().then(
        (value) {
          if (null == value) {
            setState(() => _status = _Status.none);
            return;
          }
          showDialog(
            context: context,
            child: AlertDialog(
              content: Text(value),
              actions: [
                FlatButton(
                  child: Text('GOT IT'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
          setState(() => _status = _Status.done);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _status == _Status.doing,
      child: Scaffold(
        body: Center(

            child: FlatButton(
          child: Text(_status.toString()),
          onPressed: () => onPressed(context),
        )),
      ),
    );
  }
}
