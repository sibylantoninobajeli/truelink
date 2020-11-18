import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:truelink/globals.dart' as globals;
import 'login_screen_presenter.dart';

class LoginScreenNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenNewState();
  }
}

class LoginScreenNewState extends State<LoginScreenNew>
    implements LoginScreenContract {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String _password, _username;
  LoginScreenPresenter _presenter;
  bool _isObscured = true;


  @override
  initState() {
    super.initState();
    debugPrint(" LoginScreenNewState");
  }


  LoginScreenNewState() {
    _presenter = LoginScreenPresenter(this);
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      print("$value");
    });
  }
  void onLoginError(String errorTxt) {
    /*
    globals.isJustRegistered().then((isJust){

      setState(() => _isLoading = false);
      //_showSnackBar(errorTxt);
      showDemoDialog<String>(
          context: context,
          child: CupertinoAlertDialog(
            title: const Text('Per favore, riprova ...'),
            content: Text(
                isJust?'Il nome utente e la password inseriti non sono validi. Per favore, controlla e riprova. Se ti sei appena registrato ricorda che per poter utilizzare l''app devi prima confermare la tua mail cliccando sul link che ti abbiamo inviato':'Il nome utente e la password inseriti non sono validi. Per favore, controlla e riprova.'),
            actions: <Widget>[

              CupertinoDialogAction(
                child: const Text('OK'),
                isDefaultAction: true,
                onPressed: () {
                  //_doAskPosition(_completeUser.id);
                  Navigator.of(context, rootNavigator: true)
                      .pop("Conferma");
                },
              ),
            ],
          )
      );


    });
    */
  }

  void onLoginSuccess() async {
    /*_showSnackBar(globals.localUserCtx.globalIsatutenteProfile.toString());
    setState(() => _isLoading = false);

    globals.authStateProvider.notifyState(AuthState.LOGGED_IN);
    Navigator.of(context).pop();*/
  }


  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }


  void _showSnackBar(String text) {

  }

  void _commuteObscurePws() {
    setState(() {
      _isObscured = _isObscured ? false : true;
      print(_isObscured);
    });
  }

  static void openChangePwd(BuildContext context) {
    /*
    print("Cliccked openChangePwd");

    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "Reimposta password",
          builder: (BuildContext context) => ChangePwdScreen()),
    );*/

  }

  @override
  Widget build(BuildContext context) {


    void _back(BuildContext context) {
      print("_back fun");
      Navigator.of(context).pop(true);
    }

    var backBtn = RaisedButton(
      onPressed: () {
        _back(context);
      },
      child: Text(
        "NON HAI UN ACCOUNT",
        style: globals.isaTextStyleBoldBlueMedium,
      ),

      //color: Colors.primaries[0],
    );

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      navigationBar: CupertinoNavigationBar(
        middle: globals.isaTopTitleImage,
      ),
      child: SafeArea(
          top: false,
          bottom: false,
          child:

          Container(
              child: Center(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 0.0,
                      child: Container(
                        padding: const EdgeInsets.only(top: 180.0),
                        width: 300.0,
                        //height: 400.0,
                        child: Column(
                          children: <Widget>[
                            //Expanded(child: Container()),

/*


                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text(
                                    CustomLocalizations.of(context).loginPageMex,
                                    textScaleFactor: 2.0,
                                    style: globals.isaTextStyleBoldBlackMedium,
                                    textAlign: TextAlign.left,
                                  ),


                                  TextFormField(
                                    style: globals.isaTextStyleBoldBlueMedium,
                                    onSaved: (val) => _username = val,
                                    initialValue: initialValueUsername,
                                    validator: (val) {
                                      return val.length < globals.minLoginCharNum
                                          ? CustomLocalizations.of(context).messaggioMinUsernameLengthMex(globals.minLoginCharNum)
                                          : null;
                                    },
                                    decoration:
                                    InputDecoration(labelText: CustomLocalizations.of(context).usernameLabel),
                                  ),

                                  TextFormField(
                                    style: globals.isaTextStyleBoldBlueMedium,
                                    obscureText: _isObscured,
                                    onSaved: (val) => _password = val,
                                    initialValue: initialValuePassword,
                                    decoration:
                                    InputDecoration(labelText: CustomLocalizations.of(context).passwordLabel),
                                  ),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      key: Key('__loginform_showpwd__'),
                                      onTap: () => _commuteObscurePws(),
                                      child: Text(
                                          _isObscured
                                              ? CustomLocalizations.of(context).mostraPasswordMex
                                              : CustomLocalizations.of(context).nascondiPasswordMex,
                                          textAlign: TextAlign.left,
                                          style: globals
                                              .isaTextStyleBoldBlueSmall),
                                    ),

                                  ),

                                  (globals.getEndPoint().contains("8000"))?
                                  Container(child: Text(globals.getEndPoint())):
                                  Container(),

                                ],
                              ),
                            ),


*/



/*

                            Expanded(child: Container()),
                            //backBtn,
                            Container(
                              //color:Colors.grey,
                              //color: Color(0Xfff0f0f0),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      key: Key('__loginform_changepwd__'),
                                      onTap: () {
                                        openChangePwd(context);
                                      },
                                      child:  Text(CustomLocalizations.of(context).loginLostPasswordMex,
                                          style: globals.isaTextStyleBoldBlueMedium),),

                                    Expanded(child: Container()),
                                    _isLoading
                                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(globals.circularProgressColor))
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        key: Key('__loginform_loginbtn__'),
                                        onTap: () => _submit(),
                                        child: Container(
                                          width: 80.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            color: globals.blupingColor,
                                            border: Border.all(
                                                color: Colors.white, width: 2.0),
                                            borderRadius:
                                            BorderRadius.circular(26 / 1.5),
                                          ),
                                          child: Center(
                                            child: Text(  CustomLocalizations.of(context).chooserLoginMex,
                                                style: globals
                                                    .isaTextStyleBoldWhiteMedium),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),


                            */
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
