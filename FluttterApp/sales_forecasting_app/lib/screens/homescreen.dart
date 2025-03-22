import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController productCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController customerSegmentController = TextEditingController();
  final TextEditingController marketingSpendController = TextEditingController();

  String prediction = "";

  Future<void> getPrediction() async {
    final url = Uri.parse("http://127.0.0.1:8000/predict"); // If using emulator, change to "http://10.0.2.2:8000/predict"

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Product_Category": int.parse(productCategoryController.text),
          "Price": double.parse(priceController.text),
          "Discount": double.parse(discountController.text),
          "Customer_Segment": int.parse(customerSegmentController.text),
          "Marketing_Spend": double.parse(marketingSpendController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          prediction = "Predicted Sales: ${data["prediction"]}";
        });
      } else {
        setState(() {
          prediction = "Failed to get prediction. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        prediction = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales Forecasting")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productCategoryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Product Category"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Price"),
            ),
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Discount"),
            ),
            TextField(
              controller: customerSegmentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Customer Segment"),
            ),
            TextField(
              controller: marketingSpendController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Marketing Spend"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getPrediction,
              child: Text("Predict"),
            ),
            SizedBox(height: 20),
            Text(
              prediction,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
