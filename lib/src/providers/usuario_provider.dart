import 'dart:convert';

import 'package:FormValidation/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseApiKey = 'AIzaSyCIDnb1F2dyVMqtPcDnCBVNunaAJPQqOA0';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> nuevoUsuario(String email, String pass) async {
    final authData = {
      'email' : email,
      'password' : pass,
      'returnSecureToken' : true
    };

    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseApiKey',
      body: json.encode(authData)
    );
    Map<String, dynamic> decodedResp = json.decode(res.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token' : decodedResp['idToken']};
    } else {
      return {'ok' : false, 'mensaje' : decodedResp['error']['message']};
    }
  }
//--------------------------------------------------------------------------
//---------------------------------------------------------------------------

  Future<Map<String, dynamic>> login(String email, String pass) async {
    final authData = {
      'email' : email,
      'password' : pass,
      'returnSecureToken' : true
    };

    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseApiKey',
      body: json.encode(authData)
    );
    Map<String, dynamic> decodedResp = json.decode(res.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token' : decodedResp['idToken']};
    } else {
      return {'ok' : false, 'mensaje' : decodedResp['error']['message']};
    }
  }

}