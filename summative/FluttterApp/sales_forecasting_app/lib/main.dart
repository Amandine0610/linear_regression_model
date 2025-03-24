import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      brightness: Brightness.light,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    darkTheme: ThemeData(
      primarySwatch: Colors.teal,
      brightness: Brightness.dark,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    ),
    themeMode: ThemeMode.system,
    home: SportsPremiumPredictor(),
  ));
}

class SportsPremiumPredictor extends StatefulWidget {
  @override
  _SportsPremiumPredictorState createState() => _SportsPremiumPredictorState();
}

class _SportsPremiumPredictorState extends State<SportsPremiumPredictor> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController marketingSpendController = TextEditingController();

  String predictionResult = "";
  double predictedSales = 0.0;
  bool isLoading = false;
  List<Map<String, dynamic>> predictionHistory = [];

  String? validateInput(String field, String? value) {
    if (value == null || value.isEmpty) return "$field is required";
    final numValue = double.tryParse(value);
    if (numValue == null) return "Enter a valid number for $field";
    switch (field) {
      case "Price":
        if (numValue < 0 || numValue > 1000) return "Price must be 0-1000";
        break;
      case "Discount":
        if (numValue < 0 || numValue > 50) return "Discount must be 0-50";
        break;
      case "Marketing Spend":
        if (numValue < 0 || numValue > 10000) return "Marketing Spend must be 0-10000";
        break;
    }
    return null;
  }

  Future<void> predictSales() async {
    setState(() {
      isLoading = true;
      predictionResult = "";
    });

    // Validate inputs
    String? priceError = validateInput("Price", priceController.text);
    String? discountError = validateInput("Discount", discountController.text);
    String? marketingError = validateInput("Marketing Spend", marketingSpendController.text);

    if (priceError != null || discountError != null || marketingError != null) {
      setState(() {
        predictionResult = [priceError, discountError, marketingError]
            .where((e) => e != null)
            .join("\n");
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse("https://linear-regression-model-2-v1gt.onrender.com/predict");

    final Map<String, dynamic> inputData = {
      "price": double.parse(priceController.text),
      "discount": double.parse(discountController.text),
      "marketing_spend": double.parse(marketingSpendController.text),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          predictedSales = jsonResponse["predicted_units_sold"].toDouble();
          predictionResult = "${predictedSales.toStringAsFixed(2)} units";
          predictionHistory.add({
            "price": inputData["price"],
            "discount": inputData["discount"],
            "marketing_spend": inputData["marketing_spend"],
            "prediction": predictedSales,
            "timestamp": DateTime.now().toString(),
          });
        });
      } else if (response.statusCode == 422) {
        setState(() {
          predictionResult = "Error: Values out of range (Price: 0-1000, Discount: 0-50, Marketing: 0-10000)";
        });
      } else {
        setState(() {
          predictionResult = "Error: Server returned ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Failed to connect: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void resetForm() {
    priceController.clear();
    discountController.clear();
    marketingSpendController.clear();
    setState(() {
      predictionResult = "";
      predictedSales = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sports Premium Predictor"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(history: predictionHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.sports, size: 48, color: Colors.teal),
                        SizedBox(height: 8),
                        Text(
                          "Premium Sales Prediction",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Forecast sales for premium sports products",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        InputField(
                          controller: priceController,
                          label: "Price",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          prefix: "\$",
                        ),
                        SizedBox(height: 16),
                        InputField(
                          controller: discountController,
                          label: "Discount",
                          icon: Icons.discount,
                          keyboardType: TextInputType.number,
                          suffix: "%",
                        ),
                        SizedBox(height: 16),
                        InputField(
                          controller: marketingSpendController,
                          label: "Marketing Spend",
                          icon: Icons.campaign,
                          keyboardType: TextInputType.number,
                          prefix: "\$",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Reset"),
                        onPressed: resetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.analytics),
                        label: Text(isLoading ? "Predicting..." : "Predict"),
                        onPressed: isLoading ? null : predictSales,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                if (predictionResult.isNotEmpty)
                  ResultCard(
                    prediction: predictionResult,
                    predictedValue: predictedSales,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? prefix;
  final String? suffix;

  const InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        prefixText: prefix,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
    );
  }
}

class ResultCard extends StatelessWidget {
  final String prediction;
  final double predictedValue;

  const ResultCard({
    required this.prediction,
    required this.predictedValue,
  });

  @override
  Widget build(BuildContext context) {
    bool isError = prediction.startsWith("Error") || prediction.startsWith("Failed");
    return Card(
      elevation: 4,
      color: isError ? Colors.red.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isError ? Colors.red : Colors.teal, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              isError ? "Error" : "Prediction Result",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              prediction,
              style: TextStyle(
                fontSize: 20,
                color: isError ? Colors.red : Colors.teal,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isError && predictedValue > 0) ...[
              SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: SimpleBarChart(value: predictedValue),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final double value;

  const SimpleBarChart({required this.value});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: value * 1.5,
        minY: 0,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text('Sales'),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 40,
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction History"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No predictions yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[history.length - 1 - index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      "Predicted: ${item['prediction'].toStringAsFixed(2)} units",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Price: \$${item['price']} | Discount: ${item['discount']}% | Marketing: \$${item['marketing_spend']}",
                    ),
                    trailing: Text(
                      item['timestamp'].substring(0, 19),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}