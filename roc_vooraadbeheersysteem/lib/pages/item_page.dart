// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class ItemPage extends BasePage {
  const ItemPage({Key? key}) : super(key: key);

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Item Page',
        style: TextStyle(color: Color(0xff3f2e56)),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding to the entire page
      child: ProductTable(),
    );
  }
}

class ProductTable extends StatefulWidget {
  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All'; // Default category for filter

  // Example product data
  List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Product A',
      'status': 'Good condition',
      'group': 'Tech',
      'availability': 'Taken',
      'rentedBy': 'STUDENT NAME',
      'rentedFor': '3 weeks remaining',
      'notes': 'no notes',
      'img': 'THIS IS AN IMAGE',
    },
    {
      'id': 2,
      'name': 'Radhan',
      'status': 'Good condition',
      'group': 'Tech',
      'availability': 'Available',
      'rentedBy': 'Derik',
      'rentedFor': '2 weeks remaining',
      'notes': 'no notes',
      'img': 'THIS IS AN IMAGE',
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products; // Initialize with all products
  }

  void _filterProducts() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product['name'].toLowerCase().contains(searchText);
        final matchesCategory = _selectedCategory == 'All' || product['group'] == _selectedCategory;
        return matchesSearch && matchesCategory;
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
              // Search Bar
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _filterProducts(),
                ),
              ),
              const SizedBox(width: 10),
              // Category Filter
              DropdownButton<String>(
                value: _selectedCategory,
                items: ['All', 'Tech', 'Furniture']
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _filterProducts();
                  });
                },
              ),
            ],
          ),
        ),
        // Data Table
        Expanded( // Use Expanded to make the DataTable fill the remaining space
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 50,
              dataRowHeight: 60.0,
              headingRowHeight: 50,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Group',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Availability',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Rented by',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Rented for',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Notes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'IMG',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
              rows: _filteredProducts.map((product) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(product['id'].toString())), // Ensure id is converted to String
                    DataCell(Text(product['name'] ?? '')), // Handle potential null value
                    DataCell(Text(product['status'] ?? '')),
                    DataCell(Text(product['group'] ?? '')),
                    DataCell(Text(product['availability'] ?? '')),
                    DataCell(Text(product['rentedBy'] ?? '')),
                    DataCell(Text(product['rentedFor'] ?? '')),
                    DataCell(Text(product['notes'] ?? '')),
                    DataCell(Text(product['img'] ?? '')),
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
