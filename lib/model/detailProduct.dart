import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/providers/cartProduct.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/constants/ecommerce_impl.dart';
import 'package:hive/hive.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key, required this.ecommerce}) : super(key: key);

  final EcommerceData ecommerce;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late Box<CartProduct> cartBox;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartProduct>(cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.pink[300],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500,
              width: double.infinity,
              child: Image.network(
                widget.ecommerce.image,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.ecommerce.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${widget.ecommerce.rating.rate}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(${widget.ecommerce.rating.count})',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.ecommerce.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[400],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.ecommerce.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartBox = Hive.box<CartProduct>(cart);
          cartBox.add(
            CartProduct(
              title: widget.ecommerce.title,
              description: widget.ecommerce.description,
              category: widget.ecommerce.category,
              image: widget.ecommerce.image,
              price: widget.ecommerce.price,
              id: widget.ecommerce.id,
              quantity: 1,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added to cart'),
              backgroundColor: Colors.pink[100],
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Icon(Icons.favorite),
        backgroundColor: Colors.pink[400],
      ),
    );
  }
}
