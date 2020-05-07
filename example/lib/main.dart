import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ProgressHUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ProgressHUD'),
      ),
      body: ListView(
        children: <Widget>[
          _buildListItem(context, title: 'Show default', onTap: () => _buildDefaultHud(context).show()),
          _buildListItem(context, title: 'Show for 3 seconds', onTap: () {
            var progressHud = _buildUnCancelableHud(context);
            progressHud.show();
            Future.delayed(Duration(seconds: 3), () {
              progressHud.dismiss();
            });
          }),
          _buildListItem(context, title: 'Show with background dimless', onTap: () => _buildNoDimBackgroundHud(context).show()),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {String title, VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0,
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  FlutterProgressHud _buildDefaultHud(BuildContext context) {
    return FlutterProgressHud(
      context,
      cancelable: true,
      canceledOnTouchOutside: true,
      dimBackground: true,
      hudColor: Color(0xDDFFFFFF),
      indicatorColor: Color(0x99000000),
    );
  }

  FlutterProgressHud _buildUnCancelableHud(BuildContext context) {
    return FlutterProgressHud(
      context,
      cancelable: false,
      canceledOnTouchOutside: false,
      dimBackground: true,
      hudColor: Color(0xDDFFFFFF),
      indicatorColor: Color(0x99000000),
    );
  }

  FlutterProgressHud _buildNoDimBackgroundHud(BuildContext context) {
    return FlutterProgressHud(
      context,
      cancelable: true,
      canceledOnTouchOutside: true,
      dimBackground: false,
      hudColor: Color(0x99000000),
      indicatorColor: Color(0xFFFFFFFF),
    );
  }
}
