import 'package:FormValidation/src/blocs/provider.dart';
import 'package:FormValidation/src/pages/home_page.dart';
import 'package:FormValidation/src/pages/login_page.dart';
import 'package:FormValidation/src/pages/producto_page.dart';
import 'package:FormValidation/src/pages/registro_page.dart';
import 'package:FormValidation/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Provider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
          'login'    : (BuildContext context) => LoginPage(),
          'home'     : (BuildContext context) => HomePage(),
          'producto' : (BuildContext context) => ProductoPage(),
          'registro' : (BuildContext context) => RegistroPage()
        },
      ),
    );
  }
}