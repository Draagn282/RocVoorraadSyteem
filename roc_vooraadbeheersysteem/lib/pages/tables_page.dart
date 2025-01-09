import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';
import 'package:roc_vooraadbeheersysteem/models/category_model.dart';
import 'package:roc_vooraadbeheersysteem/models/item_model.dart';
import 'package:roc_vooraadbeheersysteem/models/Status_model.dart';

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
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text(
            'Items Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          CreateDialog(),
          SizedBox(height: 10),
          ItemsTable(),
          SizedBox(height: 20),
          Text(
            'Categories Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CategoriesTable(),
          SizedBox(height: 20),
          Text(
            'Status Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          StatusTable(),
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
  List<Item> _items = [];
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items during initialization
  }

  Future<void> _fetchItems() async {
    final itemsData = await DatabaseHelper.instance.getAllItems();
    setState(() {
      _items = itemsData.map((item) => Item.fromMap(item)).toList();
      _filteredItems = List.from(_items); // Clone the list
    });
  }

  void _filterItems() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        return item.name?.toLowerCase().contains(searchText) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search Items by Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _filterItems(),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 300,
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
                DataColumn(label: Text('Notes')),
                // DataColumn(label: Text('IMG')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _filteredItems.map((item) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(item.id.toString())),
                    DataCell(Text(item.name ?? '')),
                    DataCell(Text(item.statusID?.toString() ?? 'N/A')),
                    DataCell(Text(item.categorieID?.toString() ?? 'N/A')),
                    DataCell(
                        Text(item.availablity ? 'Available' : 'Unavailable')),
                    DataCell(Text(item.notes ?? '')),
                    // DataCell(Text(item.image ?? '')),
                    DataCell(Row(
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
  final _categorieController = TextEditingController();
  final _availabilityController = TextEditingController();

  final _imgController = TextEditingController();

  Item createItemFromControllers() {
    return Item(
      id: 0, // Assuming this is an auto-incrementing field
      statusID: int.tryParse(_statusController.text) ??
          0, // Parse to int or default to 0
      categorieID: 0, // You might need to get this from another source
      name: _nameController.text,
      availablity: _availabilityController.text.toLowerCase() ==
          'true', // Convert to bool (case-insensitive)
      notes: _notesController.text,
      image: Uint8List(0),
    );
  }

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
                controller: _categorieController,
                decoration: const InputDecoration(labelText: 'categorie'),
              ),
              TextField(
                controller: _availabilityController,
                decoration: const InputDecoration(labelText: 'availability'),
              ),
              TextField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: 'img'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {Navigator.pop(context, 'Cancel')},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Item.create(
                  _nameController,
                  _notesController,
                  _imgController,
                );
                // Close the dialog
                Navigator.pop(context, 'Create');
              },
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
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categoriesData = await DatabaseHelper.instance.getAllItems();
    setState(() {
      _categories =
          categoriesData.map((category) => Category.fromMap(category)).toList();
      _filteredCategories = List.from(_categories); // Clone the list
    });
  }

  void _filterCategories() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categories.where((category) {
        return category.name.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search Categories by Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _filterCategories(),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 50,
              dataRowHeight: 60.0,
              headingRowHeight: 50,
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _filteredCategories.map((category) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(category.id.toString())),
                    DataCell(Text(category.name)),
                    DataCell(Row(
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

class StatusTable extends StatefulWidget {
  const StatusTable({Key? key}) : super(key: key);

  @override
  _StatusTableState createState() => _StatusTableState();
}

class _StatusTableState extends State<StatusTable> {
  final _searchController = TextEditingController();
  List<Status> _statuses = [];
  List<Status> _filteredStatuses = [];

  @override
  void initState() {
    super.initState();
    _fetchStatuses();
  }

  Future<void> _fetchStatuses() async {
    final statusData = await DatabaseHelper.instance.getAllStatuses();
    setState(() {
      _statuses = statusData.map((status) => Status.fromMap(status)).toList();
      _filteredStatuses = List.from(_statuses); // Clone the list
    });
  }

  void _filterStatuses() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredStatuses = _statuses.where((status) {
        return status.name.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search Status by Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _filterStatuses(),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 50,
              dataRowHeight: 60.0,
              headingRowHeight: 50,
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _filteredStatuses.map((status) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(status.id.toString())),
                    DataCell(Text(status.name)),
                    DataCell(Row(
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
