import 'dart:convert';
import 'dart:io';
import 'package:FormValidation/src/models/producto_model.dart';
import 'package:FormValidation/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-6d482.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final res = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final res =  await http.get(url);
    final List<ProductoModel> productos = new List();
    final Map<String,dynamic> decodedData = json.decode(res.body);
    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((key, prod) { 
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = key;
      productos.add(prodTemp);
    });

    // print(productos);
    return productos;
  }

  Future<bool> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final res = await http.delete(url);
    print(json.decode(res.body));

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final res = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(res.body);
    print(decodedData);
    return true;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/djt33bijl/image/upload?upload_preset=vyo9vlnu');
    final mimetype =  mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path, 
      contentType: MediaType(mimetype[0], mimetype[1])
    );

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);

    if (res.statusCode != 200 && res.statusCode != 201) {
      print('algo salio mal');
      print(res.body);
      return null;
    }

    final resData = json.decode(res.body);
    print(resData);
    return resData['secure_url'];
  }
}