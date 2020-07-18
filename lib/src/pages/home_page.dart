import 'package:FormValidation/src/blocs/provider.dart';
import 'package:FormValidation/src/models/producto_model.dart';
import 'package:FormValidation/src/providers/productos_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearLista(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto')
    );
  }

  _crearLista(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(productos[i], context, productosBloc),
          );
        } else {
          return Center( child: CircularProgressIndicator());
        }
      }
    );
  }

  _crearItem(ProductoModel producto, BuildContext context, ProductosBloc productosBloc) {
    return Dismissible(
      onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
      direction: DismissDirection.startToEnd,
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.delete),
            Text('Eliminar Producto')
          ],
        ),
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null) 
            ? Image(image: AssetImage('assets/no-image.png'),) 
            : FadeInImage(placeholder: AssetImage('assets/jar-loading.gif'), image: NetworkImage(producto.fotoUrl), height: 300.0,width: double.infinity, fit: BoxFit.cover,),
            ListTile(
              title: Text(producto.titulo),
              subtitle: Text(producto.valor.toString()),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );
  }
}