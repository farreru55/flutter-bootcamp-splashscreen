import 'dart:convert';

import 'package:flutter_application_1/model/auth.dart';
import 'package:flutter_application_1/model/config.dart';
import 'package:flutter_application_1/model/product_model.dart';
import 'package:http/http.dart';

class ProductApi {
  Client client = Client();

    Future<List<Product>> getProduct({String? query}) async {
      final headers = await Auth.getHeaders();
      final url = Uri.parse("${Config().baseUrl}/product").replace(
        queryParameters: query != null && query.isNotEmpty ? {'q': query} : null,
      );

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as List<dynamic>;

        // Mapping data ke model
        return data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        print("Failed to load product. Status code: ${response.statusCode}");
        return [];
      }
    }

    Future<bool> createProduct(Product data) async {
      final headers = await Auth.getHeaders();
      final response = await client.post(
        Uri.parse("${Config().baseUrl}/product"),
        headers: headers,
        body: productToJson(data)
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    Future<bool> updateProduct(Product data) async {
      final headers = await Auth.getHeaders();
      final response = await client.put(
        Uri.parse("${Config().baseUrl}/product/${data.id}"),
        headers: headers,
        body: productToJson(data)
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    Future<bool> deleteProduct(int id) async {
      final headers = await Auth.getHeaders();
      final response = await client.delete(
        Uri.parse("${Config().baseUrl}/product/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
}