import 'dart:async';

import 'package:FormValidation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _passController  = BehaviorSubject<String>();

  //Recuperar datos del stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passStream  => _passController.stream.transform(validarPassword);

  Stream<bool> get formStream => Rx.combineLatest2(emailStream, passStream, (e, p) => true);


  //insertar valores a los streams
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass => _passController.sink.add;

  //Obtener valores de los streams
  String get email    => _emailController.value;
  String get password => _passController.value;


  dispose() {
    _emailController?.close();
    _passController?.close();
  }
}