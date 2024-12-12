import 'dart:convert';

class Product {
  int? id;
  String? image;
  String? name;
  String? description;
  int? price;
  int? shipping_cost;
  int? is_available;
  int? product_category_id;
  DateTime? created_at;

  Product(
      {this.id,
      this.image,
      this.name,
      this.description,
      this.price,
      this.shipping_cost,
      this.is_available,
      this.product_category_id,
      this.created_at});
  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["id"],
        image: map["image"],
        name: map["name"],
        description: map["description"],
        price: map["price"],
        shipping_cost: map["shipping_cost"],
        is_available: map["is_available"],
        product_category_id: map["product_category_id"],
        created_at: DateTime.parse(map["created_at"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "description": description,
      "price": price,
      "shipping_cost": shipping_cost,
      "is_available": is_available,
      "product_category_id": product_category_id,
      "created_at": created_at?.toIso8601String()
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, image: $image, name: $name,  description: $description, price: $price, shipping_cost: $shipping_cost, is_available: $is_available, product_category_id: $product_category_id, created_at: $created_at}';
  }
}

List<Product> productFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(
      (data as List).map((item) => Product.fromJson(item)));
}

String productToJson(Product data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
