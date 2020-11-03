import 'package:truelink/models/isatutenze.dart';
import 'package:truelink/models/user.dart';
import 'package:truelink/globals.dart' as globals;
//import 'package:truelink/services/logicBinding.dart';


abstract class LoginScreenContract {
  void onLoginSuccess();
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  LoginScreenPresenter(this._view);

  Future doLogin(String username, String password) async{
    /*
      if((globals.isRelease)||(!globals.skipLoginPhase)) {
        await LogicBinding.lbLogin(username, password).then((isRegistered){
          if (isRegistered)
            _view.onLoginSuccess();
          else
            _view.onLoginError("not registered");
        }).catchError((error){
          _view.onLoginError(error.toString());
        });
      }else{
        User user=new User(0,"Fake","fakepwd","FakesLastname","FakesFirstname","FakeEmail",DateTime.now());
        globals.localUserCtx.globalIsatutenteProfile=new Isatutenze(user,"",false,false,false,false,"","","",);
        _view.onLoginSuccess();
      }*/

  }





}
