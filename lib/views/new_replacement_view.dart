import 'dart:io';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewReplacementPage extends StatefulWidget {
  const NewReplacementPage({super.key});

  @override
  State<NewReplacementPage> createState() => _NewReplacementPageState();
}

class _NewReplacementPageState extends State<NewReplacementPage> {
  final _formKey = GlobalKey<FormState>();
  final _product1Controller = TextEditingController();
  final _product2Controller = TextEditingController();
  final _product1urlController = TextEditingController();
  final _product2urlController = TextEditingController();

  File? _prod1ImageFile;
  File? _prod2ImageFile;

  final ImagePicker _prod1ImagePicker = ImagePicker();
  final ImagePicker _prod2ImagePicker = ImagePicker();

  @override
  void dispose() {
    _product1Controller.dispose();
    _product2Controller.dispose();
    _product1urlController.dispose();
    _product2urlController.dispose();
    _prod1ImageFile = null;
    _prod2ImageFile = null;

    super.dispose();
  }

  void pickProd1Image() async {
    final pickedImage =
        await _prod1ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _prod1ImageFile = File(pickedImage.path);
      }
    });
  }

  void pickProd2Image() async {
    final pickedImage =
        await _prod2ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _prod2ImageFile = File(pickedImage.path);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String product1 = _product1Controller.text;
      String product2 = _product2Controller.text;
      String product1Url = _product1urlController.text;
      String product2Url = _product2urlController.text;

      print('Product 1: $product1');
      print('Product 2: $product2');
      print('product 1 url: $product1Url');
      print('Product 2 url: $product2Url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Replacement'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Old product',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _product1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Old product name',
                        ),
                        validator: (value) {
                          return productNameValidator(value);
                        },
                      ),
                      TextFormField(
                        controller: _product1urlController,
                        decoration: const InputDecoration(
                          labelText: 'URL',
                        ),
                        validator: (value) {
                          print('url: $value');
                          if (value != null &&
                              value.isNotEmpty &&
                              !isUrl(value)) {
                            return 'Enter valid URL';
                          }
                          return null;
                        },
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        child: _prod1ImageFile == null
                            ? const Icon(Icons.add_a_photo, color: Colors.grey)
                            : Image.file(
                                _prod1ImageFile as File,
                                fit: BoxFit.contain,
                              ),
                      ),
                      ElevatedButton(
                          onPressed: pickProd1Image,
                          child: const Text('Pick Image')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ProductInput(
                title: "New Product",
                productController: _product2Controller,
                producturlController: _product2urlController,
                pickProdImage: pickProd2Image,
                prodImageFile: _prod2ImageFile,
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductInput extends StatelessWidget {
  final String title;
  final TextEditingController productController;
  final TextEditingController producturlController;
  final File? prodImageFile;
  final VoidCallback pickProdImage;

  const ProductInput({
    super.key,
    required this.title,
    required this.productController,
    required this.producturlController,
    required this.pickProdImage,
    this.prodImageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: productController,
              decoration: const InputDecoration(
                labelText: 'Product name',
              ),
              validator: (value) {
                return productNameValidator(value);
              },
            ),
            TextFormField(
              controller: producturlController,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
              validator: (value) {
                print('url: $value');
                if (value != null && value.isNotEmpty && !isUrl(value)) {
                  return 'Enter valid URL';
                }
                return null;
              },
            ),
            Container(
              height: 120,
              width: 120,
              child: prodImageFile == null
                  ? const Icon(Icons.add_a_photo, color: Colors.grey)
                  : Image.file(
                      prodImageFile as File,
                      fit: BoxFit.contain,
                    ),
            ),
            ElevatedButton(
                onPressed: pickProdImage, child: const Text('Pick Image')),
          ],
        ),
      ),
    );
  }
}

String? productNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the name of Product 1';
  } else if (value.length >= 20) {
    return 'Product name is too long';
  }
  return null;
}

bool isUrl(String url) {
  RegExp urlPattern = RegExp(
      r"^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9]+\.[^\s]+",
      caseSensitive: false,
      multiLine: false);

  return urlPattern.hasMatch(url);
}
