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

  Future<void> predictSales() async {
    setState(() {
      isLoading = true;
      predictionResult = "";
    });

    // Use your Render URL here
    final url = Uri.parse("https://linear-regression-model-2-v1gt.onrender.com/predict");

    final Map<String, dynamic> inputData = {
      "price": double.tryParse(priceController.text) ?? 0.0,
      "discount": double.tryParse(discountController.text) ?? 0.0,
      "marketing_spend": double.tryParse(marketingSpendController.text) ?? 0.0,
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
        });
      } else {
        setState(() {
          predictionResult = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Failed: $e";
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
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

                // Input Card
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

                // Buttons
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

                // Result Card
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
    return Card(
      elevation: 4,
      color: Colors.teal.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Prediction Result",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, size: 48, color: Colors.teal),
                      SizedBox(height: 8),
                      Text(
                        "Predicted Sales",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        prediction,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (predictedValue > 0)
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: SimpleBarChart(value: predictedValue),
                    ),
                  ),
              ],
            ),
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