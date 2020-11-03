import 'package:flutter/material.dart';
import 'package:truelink/globals.dart' as globals;



class PageSelectorStfl extends StatefulWidget {
  const PageSelectorStfl({this.widgetPages});
  final List<Widget> widgetPages;
  @override
  _PageSelectorStflState createState() => _PageSelectorStflState();
}

class _PageSelectorStflState extends State<PageSelectorStfl> {


  @override
  void initState() {
    super.initState();
    //main.soundManager.startEntireSequence();
  }


  @override
  void dispose() {
    //main.soundManager.stopEntireSequence();

    super.dispose();
  }



  TabController controller;

    @override
  Widget build(BuildContext context) {

    //final Color color = Theme.of(context).accentColor;
    final Color color = Colors.red;
    controller = DefaultTabController.of(context);
    controller.addListener((){
      print("Indice TAB ${controller.index}");
      //main.soundManager.configureVolume(controller.index);
    });


    controller.index=(globals.isRelease||(!globals.skipIntroPhase))?0:3;

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: IconTheme(
                  data: IconThemeData(
                    size: 128.0,
                    color: color,
                  ),
                  child: TabBarView(
                      children: widget.widgetPages.map((Widget widgetPage) {
                    return widgetPage;
                    /*
                      Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: Center(
                          child: icon,
                        ),
                      ),
                    );*/
                  }).toList()),
                ),
              ),
            ],
          ),


          new Align(
              // alignment: Alignment.centered,
              alignment: const Alignment(0.0, 0.95), //
              child: TabPageSelector(controller: controller)


              ),
        ],
      ),
    );
  }
}
