import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:loading_hud/loading_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoadingHUD',
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
        title: Text('LoadingHUD'),
      ),
      body: ListView(
        children: <Widget>[
          _buildListItem(
            context,
            title: 'Show default',
            onTap: () => _buildDefaultHud(context).show(),
          ),
          _buildListItem(
            context,
            title: 'Show for 3 seconds',
            onTap: () {
              var progressHud = _buildUnCancelableHud(context);
              progressHud.show();
              Future.delayed(Duration(seconds: 3), () {
                progressHud.dismiss();
              });
            },
          ),
          _buildListItem(
            context,
            title: 'Show with background dimless',
            onTap: () => _buildNoDimBackgroundHud(context).show(),
          ),
          _buildListItem(
            context,
            title: 'Show success',
            onTap: () => _buildSuccessHud(context).show(),
          ),
          _buildListItem(
            context,
            title: 'Show error',
            onTap: () => _buildErrorHud(context).show(),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context,
      {String title, VoidCallback onTap}) {
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

  LoadingHud _buildDefaultHud(BuildContext context) {
    return LoadingHud(context);
  }

  LoadingHud _buildUnCancelableHud(BuildContext context) {
    return LoadingHud(
      context,
      cancelable: false,
      canceledOnTouchOutside: false,
    );
  }

  LoadingHud _buildNoDimBackgroundHud(BuildContext context) {
    return LoadingHud(
      context,
      dimBackground: false,
      hudColor: Color(0x99000000),
      indicator: DefaultLoadingIndicator(
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  LoadingHud _buildSuccessHud(BuildContext context) {
    return LoadingHud(
      context,
      iconSuccess: Icon(Icons.done),
      iconError: Icon(Icons.error),
      future: onSuccess(),
    );
  }

  Future<Text> onSuccess() {
    return Future.delayed(Duration(seconds: 2), () {
      return Text('That was great!');
    });
  }

  LoadingHud _buildErrorHud(BuildContext context) {
    return LoadingHud(
      context,
      hudColor: Colors.black54,
      indicator: DefaultLoadingIndicator(
        color: Color(0xFFFFFFFF),
      ),
      iconSuccess: Icon(
        Icons.done,
        color: Colors.white,
      ),
      iconError: Icon(
        Icons.error,
        color: Colors.white,
      ),
      future: onError(),
    );
  }

  Future<Text> onError() {
    try {
      return Future.delayed(Duration(seconds: 2), () {
            throw Text(
              'Something went wrong.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            );
          });
    } catch (e) {
      print(e);
    }
  }
}
