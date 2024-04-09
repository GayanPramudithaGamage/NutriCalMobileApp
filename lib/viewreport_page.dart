import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Food {
  final String name;
  final String calories;
  final String carbs;
  final String fat;
  final String protein;
  final String detected_time;

  Food(
      {required this.name,
      required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein,
      required this.detected_time});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      calories: json['calories'],
      carbs: json['carbs'],
      fat: json['fat'],
      protein: json['protein'],
      detected_time: json['detected_time'],
    );
  }
}

Future<List<Food>> fetchFoods() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/get-detected-food-info'));
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['detected_foods'];
    return jsonResponse.map((item) => Food.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load foods from API');
  }
}

class ViewReportPage extends StatefulWidget {
  @override
  _ViewReportPageState createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  late Future<List<Food>> futureFoods;

  @override
  void initState() {
    super.initState();
    futureFoods = fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Report'),
      ),
      body: FutureBuilder<List<Food>>(
        future: futureFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Calories')),
                  DataColumn(label: Text('Carbs')),
                  DataColumn(label: Text('Fat')),
                  DataColumn(label: Text('Protein')),
                  DataColumn(label: Text('Detected Time')),
                ],
                rows: (snapshot.data ?? [])
                    .map((Food food) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(food.name)),
                            DataCell(Text('${food.calories}')),
                            DataCell(Text('${food.carbs}')),
                            DataCell(Text('${food.fat}')),
                            DataCell(Text('${food.protein}')),
                            DataCell(Text(food.detected_time)),
                          ],
                        ))
                    .toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
