// lib/pages/test/test_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class TablesPage extends BasePage {
  const TablesPage({Key? key}) : super(key: key);

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Tables Page',
        style: TextStyle(color: Color(0xff3f2e56)),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding to the entire page
      child: ListView(
        children: [
          const Text(
            'Items Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          CreateDialog(),
          const SizedBox(height: 10),
          const ItemsTable(), // Add ItemsTable widget
          const SizedBox(height: 20), // Space between tables
          const Text(
            'Categories Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const CategoriesTable(), // Add CategoriesTable widget
        ],
      ),
    );
  }
}

class ItemsTable extends StatefulWidget {
  const ItemsTable({Key? key}) : super(key: key);

  @override
  _ItemsTableState createState() => _ItemsTableState();
}

class _ItemsTableState extends State<ItemsTable> {
  final _searchController = TextEditingController();
  final __nameController = TextEditingController();
  final __statusController = TextEditingController();
  final __groupController = TextEditingController();
  final __availabilityController = TextEditingController();
  final __rentedbyController = TextEditingController();
  final __renteduntilController = TextEditingController();
  final __notesController = TextEditingController();
  final __imgController = TextEditingController();
  List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'name': 'Product A',
      'status': 'Good condition',
      'group': 'Tech',
      'availability': 'Taken',
      'rentedBy': 'STUDENT NAME',
      'rentedUntil': '12-10-25',
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
      'rentedUntil': '12-10-25',
      'notes': 'no notes',
      'img': 'THIS IS AN IMAGE',
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
                    labelText: 'Search Items by Name',
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
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Group')),
                DataColumn(label: Text('Availability')),
                DataColumn(label: Text('Rented by')),
                DataColumn(label: Text('Rented Until')),
                DataColumn(label: Text('Notes')),
                DataColumn(label: Text('IMG')),
                DataColumn(label: Text('Actions')), // New Actions column
              ],
              rows: _filteredItems.map((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(item['id'].toString())),
                    DataCell(Text(item['name'] ?? '')),
                    DataCell(Text(item['status'] ?? '')),
                    DataCell(Text(item['group'] ?? '')),
                    DataCell(Text(item['availability'] ?? '')),
                    DataCell(Text(item['rentedBy'] ?? '')),
                    DataCell(Text(item['rentedUntil'] ?? '')),
                    DataCell(Text(item['notes'] ?? '')),
                    DataCell(Text(item['img'] ?? '')),
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

class CreateDialog extends StatefulWidget {
  const CreateDialog({super.key});

  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _statusController = TextEditingController();
  final _groupController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _rentedbyController = TextEditingController();
  final _renteduntilController = TextEditingController();
  final _imgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Create new item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'status'),
              ),
              TextField(
                controller: _groupController,
                decoration: const InputDecoration(labelText: 'group'),
              ),
              TextField(
                controller: _availabilityController,
                decoration: const InputDecoration(labelText: 'availability'),
              ),
              TextField(
                controller: _rentedbyController,
                decoration: const InputDecoration(labelText: 'rented by'),
              ),
              TextField(
                controller: _renteduntilController,
                decoration: const InputDecoration(labelText: 'rented until'),
              ),
              TextField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: 'img'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Create'),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

class CategoriesTable extends StatefulWidget {
  const CategoriesTable({Key? key}) : super(key: key);

  @override
  _CategoriesTableState createState() => _CategoriesTableState();
}

class _CategoriesTableState extends State<CategoriesTable> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Tech'},
    {'id': 2, 'name': 'Furniture'},
    {'id': 3, 'name': 'Books'},
  ];

  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = _categories; // Initialize with all categories
  }

  void _filterCategories() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categories.where((category) {
        return category['name'].toLowerCase().contains(searchText);
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
              // Search Bar for Categories
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Categories by Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _filterCategories(),
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
                DataColumn(label: Text('Actions')), // New Actions column
              ],
              rows: _filteredCategories.map((category) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(category['id'].toString())),
                    DataCell(Text(category['name'] ?? '')),
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
