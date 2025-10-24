import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  @override
  Widget build(BuildContext context) {
    final _priceFocus = FocusNode();
    final _descriptionFocus = FocusNode();
    final _imageUrlFocus = FocusNode();
    final _imageUrlController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    final _formData = Map<String, Object>();

    void updateImage() {
      setState(() {});
    }

    void _submitForm() {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      _formKey.currentState?.save();

      Provider.of<ProductList>(
        context,
        listen: false,
      ).addProductFromdata(_formData);
      Navigator.of(context).pop();
    }

    bool isValideImageUrl(String url) {
      bool isValideUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
      bool endWithFile =
          url.toLowerCase().endsWith('.png') ||
          url.toLowerCase().endsWith('.jpg');
      return isValideUrl && endWithFile;
    }

    @override
    void initState() {
      super.initState();
      _imageUrlFocus.addListener(updateImage);
    }

    @override
    void dispose() {
      super.dispose();
      _priceFocus.dispose();
      _descriptionFocus.dispose();
      _imageUrlFocus.removeListener(updateImage);
      _imageUrlFocus.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de produtp'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'Nome precisa ter no minimo 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '-1';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'Descrição é obrigatório';
                  }

                  if (description.trim().length < 10) {
                    return 'Descrição precisa ter no minimo 10 letras';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da imagem'),
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imagUrl) =>
                          _formData['imagUrl'] = imagUrl ?? '',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';
                        if (isValideImageUrl(imageUrl)) {
                          return 'Informe uma url válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a url')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
