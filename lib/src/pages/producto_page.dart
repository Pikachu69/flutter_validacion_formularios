import 'dart:io';
import 'package:FormValidation/src/blocs/provider.dart';
import 'package:FormValidation/src/models/producto_model.dart';
import 'package:FormValidation/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    
    if (prodData != null) producto = prodData;

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: _seleccionarFoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(context),
              ],
            )
          ),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if(utils.isNumber(value)) {
          return null;
        } else return 'Solo números';
      },
    );
  }

  _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible, 
      title: Text('Disponible'),
      onChanged: (value) {
        setState(() {
          producto.disponible = value;
        });
      }
    );
  }

  _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: (_guardando) ? null : _submit, 
      icon: Icon(Icons.save), 
      label: Text('Guardar')
    );
  }

  void _submit() async {
    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();
    setState(() {_guardando = true; Center(child: CircularProgressIndicator());});

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
      mostrarSnackbar('Nuevo producto agregado');
      Navigator.pop(context);
    } else {
      productosBloc.editarProducto(producto);
      mostrarSnackbar('Producto actualizado');
      Navigator.pop(context);
    }


    
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }


  Future _seleccionarFoto() async {
    _procesarImg(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImg(ImageSource.camera);
  }

  _procesarImg(ImageSource origen) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: origen,
    );
    foto = File(pickedFile.path);
    if (foto != null) {
      producto.fotoUrl = null;  
    }
    setState(() {});
  }
}