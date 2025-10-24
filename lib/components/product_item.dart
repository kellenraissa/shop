import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
              color: Theme.of(context).colorScheme.error,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
