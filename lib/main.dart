//Importaciones,
import 'package:flutter/material.dart'; //: Paquete de material design para widgets de Flutter.
import 'package:firebase_core/firebase_core.dart'; // : Paquete de Firebase Core que se utiliza para inicializar Firebase.
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Paquete de Firestore que se utiliza para interactuar con la base
//de datos de Firebase Firestore.
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//Instancia de firestore
final FirebaseFirestore base = FirebaseFirestore.instance;

//CONEXION CON FIREBASE
void main() async {
  //Nos aseguramos que todos los componentes de flutter se hayan inicializado.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //funcion runApp
  runApp(const MyApp());
}

//clase app usando sin estado
//Configuracion global de la aplicacion
//cambiar fuente
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  //metodo buil es obligatorio en todas las clases que hereden de Stateless
  Widget build(BuildContext context) {
    //objeto MaterialApp
    return MaterialApp(
      title: 'Sotano Coffe Lab.',
      theme: ThemeData(
        primaryColor: Colors.red[800],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
        ),
      ),
      home: const ProductList(),
    );
  }
}

/*INICIA UPDATE */
/*
Aqui usamos statefulWidget
cambiante
*/
class EditProductPage extends StatefulWidget {
  //declaramos una variable de instancia.
  //final lo hace inmutable
  final Product product;

  //constructor
  const EditProductPage({Key? key, required this.product}) : super(key: key);

  //funcion createState se encarga de crear un nuevo estado cada vez que se crea una instancia
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Rellenar los campos del formulario con los datos del producto
    _productController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _imageController.text = widget.product.image;
    _descriptionController.text = widget.product.description;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product.id, // Usar el mismo id del producto existente
        name: _productController.text,
        price: double.parse(_priceController.text),
        image: _imageController.text,
        description: _descriptionController.text,
      );
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toJson());

      Navigator.pop(context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _productController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del producto'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration:
                    const InputDecoration(labelText: 'URL de la imagen'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la URL de la imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Descripción del producto'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la descripción del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//FINALIZA UPDATE

//VER PRODUCTOS
class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  void _deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
    setState(() {}); // Actualizar la página después de eliminar el producto
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  void _goToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de productos'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProductScreen,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los productos'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.hasData
              ? snapshot.data!.docs
                  .map((doc) => Product.fromFirestore(doc))
                  .toList()
              : [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.description),
                      const SizedBox(height: 4),
                      Text('\$${product.price}'),
                    ],
                  ),
                  leading: CachedNetworkImage(
                    imageUrl: product.image,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  // Agregamos los botones de opciones
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editProduct(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*METODO DE AGREGAR PRODUCTO*/
class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

TextEditingController _imageController = TextEditingController();

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final String _imageUrl = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: const Uuid().v4(), // Generar un id aleatorio
        name: _productController.text,
        price: double.parse(_priceController.text),
        image: _imageController.text,
        description: _descriptionController.text,
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id) // Usar el id como identificador del documento
          .set(product.toJson());

      _productController.clear();
      _priceController.clear();
      _imageController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _productController,
                    decoration:
                        const InputDecoration(labelText: 'Nombre del producto'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingresa el nombre del producto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingresa el precio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(labelText: 'Imagen'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese una URL de imagen';
                      }
                      return null;
                    },
                  ),
                  _imageUrl != null
                      ? ImageFromUrl(url: _imageUrl)
                      : const SizedBox.shrink(),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Guardar'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      price: data['price'],
      image: data['image'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }

  String get productId => id;
}

class ImageFromUrl extends StatelessWidget {
  final String url;

  const ImageFromUrl({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Text(' ');
      },
    );
  }
}
