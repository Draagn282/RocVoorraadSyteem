import 'dart:developer';

import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class Item {
  final int id;
  final int statusID; // Foreign key to the status table
  final int categorieID; // Foreign key to the categorie table
  final String name;
  final bool availablity; // Boolean indicating availability
  final DateTime rented;
  final String notes; // Additional notes about the item
  final String image; // URL or path to the item's image

  Item({
    required this.id,
    required this.statusID,
    required this.categorieID,
    required this.name,
    required this.availablity,
    required this.rented,
    required this.notes,
    required this.image,
  });

  // Named constructor to create an Item from a Map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      statusID: map['statusID'] as int,
      categorieID: map['categorieID'] as int,
      name: map['name'] as String? ?? '',  // Use empty string if null
      availablity: map['availablity'] == 1, // Convert int to bool
         rented: map['rented'] != null
        ? DateTime.parse(map['rented'] as String) // Parse if not null
        : DateTime.now(), // Provide a default value if null
      notes: map['notes'] as String? ?? '', // Use empty string if null
      image: map['image'] as String? ?? '', // Use empty string if null
    );
  }


  // Method to convert an Item to a Map (for database insertions or updates)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statusID': statusID,
      'categorieID': categorieID,
      'name': name,
      'availablity': availablity ? 1 : 0, // Convert bool to int for storage
      'rented': rented,
      'notes': notes,
      'image': image,
    };
  }

  static Future<Item?> getItem(int id) async {
    try {
      // Log the function call
      log('Fetching item with id: $id');

      // Get data from the database
      final data = await DatabaseHelper.instance.getData(
        tableName: 'item',
        whereClause: 'id = 1', // Use placeholder for safety
        // whereArgs: [id],
      );

      // Check if data is returned
      if (data != null && data.isNotEmpty) {
        return Item.fromMap(data.first);
      } else {
        // log('No item found with id: $id');
      }
    } catch (e) {
      // Log any errors encountered
      log('Error fetching item with id: $id', error: e);
    }

    // Return null if no data is found or an error occurs
    return null;
  }

  Future<void> save() async {
    // Add save logic here (e.g., insert or update the item in the database)
  }

  Future<void> delete() async {
    // Add delete logic here (e.g., delete the item from the database)
  }
}
