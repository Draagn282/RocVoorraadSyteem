import 'package:flutter/material.dart';

class AdminViewProductPage extends StatefulWidget {
  const AdminViewProductPage({super.key});

  @override
  _AdminViewProductPageState createState() => _AdminViewProductPageState();
}

class _AdminViewProductPageState extends State<AdminViewProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // Dropdown selected values
  String? selectedGroup = 'Group 1'; // Default value for group
  String? selectedCondition = 'New'; // Default value for condition
  String _selectedCategory = 'All'; // Default category for filter

  // Example product data
  final List<Map<String, dynamic>> _products = [
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
    {
      'id': 3,
      'name': 'Furn',
      'status': 'Good condition',
      'group': 'Furniture',
      'availability': 'Available',
      'rentedBy': 'Derik',
      'rentedFor': '2 weeks remaining',
      'notes': 'no notes',
      'img': 'THIS IS AN IMAGE',
    },
  ];

  // Filtered list of products based on search and category
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products; // Initialize with all products
  }

  // Clean up controllers to avoid memory leaks
  @override
  void dispose() {
    _searchController.dispose();
    _productNameController.dispose();
    _notesController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch =
            product['name'].toLowerCase().contains(searchText);
        final matchesCategory =
            _selectedCategory == 'All' || product['group'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin View Products'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            DataTable(
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
                    DataCell(Text(product['id']
                        .toString())), // Ensure id is converted to String
                    DataCell(Text(
                        product['name'] ?? '')), // Handle potential null value
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

            const SizedBox(height: 20),
            // Add New Product Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'New Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _productNameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Group',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedGroup,
                      items: ['Group 1', 'Group 2', 'Group 3', 'No Group']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGroup = newValue ??
                              selectedGroup; // Use existing value if null
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Condition',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCondition,
                      items: [
                        'New',
                        'Good',
                        'Used',
                        'Bad',
                        'Repair needed',
                        'In Repair'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCondition = newValue ??
                              selectedCondition; // Use existing value if null
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform form submission actions here
                          print('Product Name: ${_productNameController.text}');
                          print('Group: $selectedGroup');
                          print('Condition: $selectedCondition');
                          print('Notes: ${_notesController.text}');
                          print('Image: ${_imageController.text}');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
