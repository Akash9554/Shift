import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement navigation logic to go back
          },
        ),
        title: Text('Product List'),
        actions: [
          DropdownButton<int>(
            onChanged: (int? selectedId) {
              // Implement logic based on the selected ID
            },
            items: [
              DropdownMenuItem<int>(
                value: 1,
                child: Text('Lastest Product'),
              ),
              DropdownMenuItem<int>(
                value: 2,
                child: Text('Oldest Product'),
              ),
              DropdownMenuItem<int>(
                value: 3,
                child: Text('Lowest Product'),
              ),
              DropdownMenuItem<int>(
                value: 4,
                child: Text('Highest Product'),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Replace with your product data
          //final product = getProductAtIndex(index);

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(""),
                Text("product.name"),
                Text('Online Price: '),
                Text('Shop Price: '),
                ElevatedButton(
                  onPressed: () {
                    // Implement add to cart logic
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}

class Product {
  final String name;
  final String imageUrl;
  final double onlinePrice;
  final double shopPrice;

  Product({
    required this.name,
    required this.imageUrl,
    required this.onlinePrice,
    required this.shopPrice,
  });
}
