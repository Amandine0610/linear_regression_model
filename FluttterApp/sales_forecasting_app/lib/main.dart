import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    ),
    themeMode: ThemeMode.system,
    home: HomeScreen(),
  ));
}

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
  
  String predictionResult = "";
  double predictedSales = 0.0;
  bool isLoading = false;
  List<Map<String, dynamic>> predictionHistory = [];
  
  Future<void> predictSales() async {
    setState(() {
      isLoading = true;
      predictionResult = "";
    });
    
    final url = Uri.parse("http://127.0.0.1:8000/predict");
    
    final Map<String, dynamic> inputData = {
      "Product_Category": int.tryParse(productCategoryController.text) ?? 0,
      "Price": double.tryParse(priceController.text) ?? 0.0,
      "Discount": double.tryParse(discountController.text) ?? 0.0,
      "Customer_Segment": int.tryParse(customerSegmentController.text) ?? 0,
      "Marketing_Spend": double.tryParse(marketingSpendController.text) ?? 0.0,
    };
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(inputData),
      );
      
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final prediction = jsonResponse["Predicted Units Sold"];
        
        setState(() {
          predictedSales = prediction.toDouble();
          predictionResult = "${prediction.toStringAsFixed(2)} units";
          
          // Add to history
          predictionHistory.add({
            ...inputData,
            "prediction": prediction,
            "timestamp": DateTime.now().toString(),
          });
        });
      } else {
        setState(() {
          predictionResult = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Failed to get prediction: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  void resetForm() {
    productCategoryController.clear();
    priceController.clear();
    discountController.clear();
    customerSegmentController.clear();
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
        title: Text("Sales Predictor"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PredictionHistoryScreen(history: predictionHistory),
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
                // Header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_cart, size: 48, color: Theme.of(context).primaryColor),
                        SizedBox(height: 8),
                        Text(
                          "Sales Prediction Tool",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enter product details to predict sales",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Input fields
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        InputField(
                          controller: productCategoryController,
                          label: "Product Category",
                          icon: Icons.category,
                          keyboardType: TextInputType.number,
                          helper: "Enter product category ID",
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                controller: priceController,
                                label: "Price",
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                prefix: "\$",
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: InputField(
                                controller: discountController,
                                label: "Discount",
                                icon: Icons.discount,
                                keyboardType: TextInputType.number,
                                suffix: "%",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        InputField(
                          controller: customerSegmentController,
                          label: "Customer Segment",
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                          helper: "Enter customer segment ID",
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
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Reset"),
                        onPressed: resetForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
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
                        label: Text(isLoading ? "Predicting..." : "Predict Sales"),
                        onPressed: isLoading ? null : predictSales,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Results card
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
  final String? helper;
  final String? prefix;
  final String? suffix;
  
  const InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.helper,
    this.prefix,
    this.suffix,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixText: prefix,
        suffixText: suffix,
        helperText: helper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Prediction Result",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Expected Sales",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        prediction,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
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
              getTitlesWidget: (value, meta) {
                return Text('Sales');
              },
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
                color: Theme.of(context).primaryColor,
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

class PredictionHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  
  const PredictionHistoryScreen({required this.history});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction History"),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No prediction history yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[history.length - 1 - index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text("${index + 1}"),
                    ),
                    title: Text(
                      "Predicted: ${item['prediction'].toStringAsFixed(2)} units",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Price: \$${item['Price']} | Discount: ${item['Discount']}% | Marketing: \$${item['Marketing_Spend']}",
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PredictionDetailsSheet(data: item),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class PredictionDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const PredictionDetailsSheet({required this.data});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Prediction Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          DetailRow("Product Category", "${data['Product_Category']}"),
          DetailRow("Price", "\$${data['Price']}"),
          DetailRow("Discount", "${data['Discount']}%"),
          DetailRow("Customer Segment", "${data['Customer_Segment']}"),
          DetailRow("Marketing Spend", "\$${data['Marketing_Spend']}"),
          Divider(height: 32),
          DetailRow(
            "Predicted Sales",
            "${data['prediction'].toStringAsFixed(2)} units",
            highlighted: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;
  
  const DetailRow(
    this.label,
    this.value, {
    this.highlighted = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
              color: highlighted ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}