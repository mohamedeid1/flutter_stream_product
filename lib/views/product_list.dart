import 'package:flutter/material.dart';
import 'package:flutter_stream_product/models/product.dart';
import 'package:flutter_stream_product/blocs/product_bloc.dart';
import 'dart:async';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  ProductsBloc productsBloc = ProductsBloc();
  @override
  void dispose() {
    productsBloc.dispose();
    super.dispose();
  }

  TextStyle _mstyle = TextStyle(fontSize: 18, color: Colors.deepPurple);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: productsBloc.productStream,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapShot.hasError) {
              return Text(' Error');
            } else {
              List<Product> products = snapShot.data;
              return Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, position) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(products[position].title, style: _mstyle),
                              Text(products[position].qlt.toString(),
                                  style: _mstyle),
                              RaisedButton(
                                  child: Text("Remove"),
                                  onPressed: () {
                                    productsBloc.removeProduct
                                        .add(products[position]);
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                      child: Text("Add New"),
                      onPressed: () {
                        Product product = Product('20', 'ahmed', 25);
                        productsBloc.addProduct.add(product);
                      }),
                ],
              );
            }

            break;
        }
      },
    );
  }
}
