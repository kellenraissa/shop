import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            // child: Column(
            //   children: [
            //     Text("Algo que nunca muda"),
            //     Text(
            //       "Child que pode passar no consumer como um widget como algo que nunca vai ser re-renderizado",
            //     ),
            //     Text("Algo que nunca muda"),
            //   ],
            // ),
            builder: (ctx, product, child) => IconButton(
              onPressed: () async {
                try {
                  Provider.of<ProductList>(
                    context,
                    listen: false,
                  ).toggleFavoriteProduct(product);
                  // product.toggleFavorite();
                } on HttpException catch (error) {
                  msg.showSnackBar(SnackBar(content: Text(error.msg)));
                }
              },

              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
          title: Text(product.name, textAlign: TextAlign.center),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
