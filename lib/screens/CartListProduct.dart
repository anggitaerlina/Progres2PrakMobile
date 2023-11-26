import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ecommerce_app/providers/cartProduct.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import '../main.dart';

class CartListProduct extends StatefulWidget {
  const CartListProduct({Key? key}) : super(key: key);

  @override
  State<CartListProduct> createState() => _CartListProductState();
}

class _CartListProductState extends State<CartListProduct> {
  late Box<CartProduct> cartBox;
  late Timer timer;
  String? formattedTime;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartProduct>(cart);
    // Timer to update time every second
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getTime();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cartBox.isEmpty
            ? Center(
          child: Text('Tidak ada data produk'),
        )
            : ListView.builder(
          itemCount: cartBox.length,
          itemBuilder: (context, index) {
            final cartProduct = cartBox.getAt(index);
            return Dismissible(
              key: Key(cartProduct!.title),
              onDismissed: (direction) {
                cartBox.deleteAt(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produk dihapus dari favorit'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildProductInfo(cartProduct),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(CartProduct? cartProduct) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // Center the title
                child: Center(
                  child: Text(
                    cartProduct?.title ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: Image.network(
            cartProduct?.image ?? '',
            fit: BoxFit.cover,
          ),
        ),
        ListTile(
          title: Text(
            ' Price',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: Text(
            '${formatPrice(cartProduct?.price ?? 0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  void getTime() async {
    try {
      Response response = await get(
          Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Jakarta"));
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];

      DateTime now = DateTime.parse(datetime);

      formattedTime = _getFormattedTime(now);
      setState(() {});
    } catch (e) {
      print('Error fetching time: $e');
    }
  }

  String _getFormattedTime(DateTime time) {
    return '${time.hour}:${time.minute}:${time.second}';
  }
}