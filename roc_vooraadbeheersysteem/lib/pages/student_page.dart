// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class StudentPage extends BasePage {
  const StudentPage({super.key});

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Student Page',
        style: TextStyle(color: Color(0xff3f2e56)),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding to the entire page
      child: ListView(
        children: const [
          Text(
            'Items Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ItemsTable(), // Add ItemsTable widget
        ],
      ),
    );
  }
}

class ItemsTable extends StatefulWidget {
  const ItemsTable({super.key});

  @override
  _ItemsTableState createState() => _ItemsTableState();
}

class _ItemsTableState extends State<ItemsTable> {
  final _searchController = TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'name': 'John Doe',
      'studentId': 'S123',
      'class': 'Class A',
      'totalBorrows': 5,
      'currentlyBorrowing': 1,
      'timesLate': 0,
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'studentId': 'S456',
      'class': 'Class B',
      'totalBorrows': 3,
      'currentlyBorrowing': 2,
      'timesLate': 1,
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _items; // Initialize with all items
  }

  void _filterItems() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        return item['name'].toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              // Search Bar for Items
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Students by Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _filterItems(),
                ),
              ),
            ],
          ),
        ),
        // Define a fixed height for the DataTable
        SizedBox(
          height: 300, // Adjust this height as needed
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 50,
              dataRowHeight: 60.0,
              headingRowHeight: 50,
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Student ID')),
                DataColumn(label: Text('Class')),
                DataColumn(label: Text('Total Borrows')),
                DataColumn(label: Text('Currently Borrowing')),
                DataColumn(label: Text('Times Late')),
                DataColumn(label: Text('Actions')), // New Actions column
              ],
              rows: _filteredItems.map((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(item['id'].toString())),
                    DataCell(Text(item['name'] ?? '')),
                    DataCell(Text(item['studentId'] ?? '')),
                    DataCell(Text(item['class'] ?? '')),
                    DataCell(Text(item['totalBorrows'].toString() ?? '0')),
                    DataCell(
                        Text(item['currentlyBorrowing'].toString() ?? '0')),
                    DataCell(Text(item['timesLate'].toString() ?? '0')),
                    DataCell(Row(
                      // Action buttons
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete action
                          },
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
