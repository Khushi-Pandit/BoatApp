import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(TravelBookingApp());

class TravelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TravelListScreen(),
    );
  }
}

class TravelListScreen extends StatefulWidget {
  @override
  _TravelListScreenState createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  List<Map<String, dynamic>> boats = [];

  Future<void> fetchBoats() async {
    final response = await http.get(Uri.parse('http://localhost:3000/boats'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        boats = data.map((boat) => {
          'name': boat['name'],
          'description': boat['description'] ?? '',
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBoats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boat Availability')),
      body: ListView.builder(
        itemCount: boats.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(boats[index]['name']!),
              subtitle: Text(boats[index]['description']!),
            ),
          );
        },
      ),
    );
  }
}

class BookingDetailScreen extends StatelessWidget {
  final Map<String, String> option;

  BookingDetailScreen({required this.option});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(option['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(option['image']!, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text('Passenger Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Text('Additional Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Add Meals'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Add Guided Tour'),
              value: false,
              onChanged: (value) {},
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to next step
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
