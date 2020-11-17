import 'package:flutter/material.dart';
import 'dart:math';
import 'package:truelink/globals.dart' as globals;
import 'package:truelink/internalnotification_subscription.dart';



class PulsarPainter extends CustomPainter {
  final Animation<double> _animation;
  final Color color;
  PulsarPainter(this._animation,this.color) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = new Color.fromRGBO(this.color.red, this.color.green, this.color.blue, opacity);

    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(PulsarPainter oldDelegate) {
    return true;
  }
}



class Pulsar extends StatefulWidget {
  @override
  PulsarState createState() => new PulsarState();
}

class PulsarState extends State<Pulsar>
    with SingleTickerProviderStateMixin
    implements InternalNotificationListener{
  AnimationController _controller;

  void onInternalNotification(InternalNotificationType type, Map<int,String> mex){
    switch(type){
      case  InternalNotificationType.STOP_READING:
        _stopAnimation();
        break;
      case InternalNotificationType.VERIFIED_NOT_ORIGINAL_PRODUCT:
        _showAlert();
        break;
      case InternalNotificationType.VERIFIED_ORIGINAL_PRODUCT:
        _showGood();
        break;
    }

    if (type == InternalNotificationType.STOP_READING){
      _stopAnimation();
    }
    if (type == InternalNotificationType.STOP_READING){
      _stopAnimation();
    }
    if (type == InternalNotificationType.STOP_READING){
      _stopAnimation();
    }
  }


  @override
  void initState() {
    super.initState();
    globals.internalPushNotificationProvider.subscribe(this);
    _controller = new AnimationController(
      vsync: this,
    );
    _pulsarPainter=new PulsarPainter(_controller,Colors.lightBlue);
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    globals.internalPushNotificationProvider.unsubscribe(this);
    super.dispose();
  }

  void _stopAnimation(){
    globals.localLog("Pulsar", "Stopping animatio");
    setState(() {
      _controller.stop();
    });
  }

  _showAlert(){
    setState(() {
      _pulsarPainter=new PulsarPainter(_controller,Colors.red);
    });
  }

  _showGood(){
    setState(() {
      _pulsarPainter=new PulsarPainter(_controller,Colors.green);
    });
  }


  PulsarPainter _pulsarPainter;

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  CustomPaint(
        painter: _pulsarPainter,
        child: new SizedBox(
          width: 200.0,
          height: 200.0,
        ),

      /*
      floatingActionButton: new FloatingActionButton(
        onPressed: _startAnimation,
        child: new Icon(Icons.play_arrow),
      ),*/
    );
  }
}