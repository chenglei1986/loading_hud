import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:loading_hud/loading_indicator.dart';

class LoadingHud<T extends Text> {
  final BuildContext context;
  final bool cancelable;
  final bool canceledOnTouchOutside;
  final bool dimBackground;
  final Color hudColor;
  final Widget indicator;
  final Widget iconSuccess;
  final Widget iconError;
  final Future<T> future;
  final Duration autoDismissDuration;

  LoadingHud(
    this.context, {
    this.cancelable = true,
    this.canceledOnTouchOutside = true,
    this.dimBackground = true,
    this.hudColor = const Color(0xDDFFFFFF),
    this.indicator = const DefaultLoadingIndicator(),
    this.iconSuccess,
    this.iconError,
    this.future,
    this.autoDismissDuration,
  });

  void show() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          child: _HudContent<T>(
            hudColor: hudColor,
            indicator: indicator,
            iconSuccess: iconSuccess,
            iconError: iconError,
            future: future,
            autoDismissDuration: autoDismissDuration,
          ),
          onWillPop: () {
            return Future.value(cancelable);
          },
        );
      },
      barrierColor: dimBackground ? Color(0x33000000) : null,
      barrierLabel: 'Dismiss',
      barrierDismissible: canceledOnTouchOutside,
      transitionDuration: const Duration(milliseconds: 250),
      useRootNavigator: true,
    );
  }

  void dismiss() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _HudContent<T extends Text> extends StatefulWidget {
  final Color hudColor;
  final Widget indicator;
  final Widget iconSuccess;
  final Widget iconError;
  final Future<T> future;
  final Duration autoDismissDuration;

  _HudContent({
    this.hudColor,
    this.indicator,
    this.iconSuccess,
    this.iconError,
    this.future,
    this.autoDismissDuration,
  });

  @override
  _HudContentState createState() => _HudContentState<T>();
}

class _HudContentState<T extends Text> extends State<_HudContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<T>(
        future: widget.future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          bool done = false;
          Widget widgetDone;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              done = true;
              widgetDone = _IconText(
                icon: widget.iconSuccess,
                text: snapshot.data,
              );
            } else if (snapshot.hasError) {
              done = true;
              widgetDone = _IconText(
                icon: widget.iconError,
                text: snapshot.error,
              );
            }
          }
          // Auto dismiss
          if (done && widget.autoDismissDuration != null) {
            Future.delayed(widget.autoDismissDuration, () {
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
          return DecoratedBox(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: done
                  ? ConstrainedBox(
                      child: widgetDone,
                      constraints: BoxConstraints(
                        minHeight: 100,
                        minWidth: 100,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(35),
                      child: widget.indicator,
                    ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: widget.hudColor,
            ),
          );
        },
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final Widget icon;
  final Text text;

  _IconText({
    @required this.icon,
    this.text,
  }) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            text.data,
            style: text.style ??
                TextStyle(
                  fontSize: 16,
                  color: Color(0xFF000000),
                  decoration: TextDecoration.none,
                ),
          ),
        ),
      ],
    );
  }
}
