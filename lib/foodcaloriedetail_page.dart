import 'package:flutter/material.dart';

class FoodCalorieDetailPage extends StatelessWidget {
  final List<Map<String, dynamic>> foodData;

  const FoodCalorieDetailPage({Key? key, required this.foodData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Information'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: foodData.length,
        itemBuilder: (context, index) {
          final food = foodData[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${food['name'] ?? 'Loading...'}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(children: [
                    const Text('Calorie Range',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${food['calorie_range'] ?? 'Loading...'}',
                        style: TextStyle(fontSize: 20)),
                  ]),
                  TableRow(children: [
                    const Text('Carbs',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${food['carbohydrate_percentage'] ?? 'Loading...'}',
                        style: TextStyle(fontSize: 20)),
                  ]),
                  TableRow(children: [
                    const Text('Fat',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${food['fat_percentage'] ?? 'Loading...'}',
                        style: TextStyle(fontSize: 20)),
                  ]),
                  TableRow(children: [
                    const Text('Protein',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${food['protein_percentage'] ?? 'Loading...'}',
                        style: TextStyle(fontSize: 20)),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
