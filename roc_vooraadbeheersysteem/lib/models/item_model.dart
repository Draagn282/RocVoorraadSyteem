import 'dart:typed_data';
import 'dart:developer';

import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class Item {
  final int? id;
  final int statusID; // Foreign key to the status table
  final int categorieID; // Foreign key to the categorie table
  final String name;
  final bool availablity; // Boolean indicating availability
  final DateTime rented;
  final String notes; // Additional notes about the item
  final Uint8List image; // Binary data for the item's image

  Item({
    this.id, //nullable
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
    final image = map['image']; // Ensure this matches your DB schema
    return Item(
      id: map['id'] as int,
      statusID: map['statusID'] as int,
      categorieID: map['categorieID'] as int,

      name: map['name'] as String? ?? '',  // Use empty string if null
      availablity: map['availablity'] == 1, // Convert int to bool
      rented: map['rented'] != null
        ? DateTime.parse(map['rented'] as String) // Parse if not null
        : DateTime.now(), // Provide a default value if null
      notes: map['notes'] as String? ?? ''  , // Use empty string if null
      image: Uint8List(0),

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
    'rented': rented.toIso8601String(), // Convert DateTime to string
      'notes': notes,
      'image': image, // Store binary data in the database
    };
  }

  static Future<Item?> getItem(int id) async {
  try {
    log('Fetching item with id: $id');

    final data = await DatabaseHelper.instance.getData(
      tableName: 'item',
      whereClause: 'id = ?', // Gebruik de placeholder '?'
      whereArgs: [id], // Bind de id parameter
    );

    if (data != null && data.isNotEmpty) {
      return Item.fromMap(data.first);
    }
  } catch (e) {
    log('Error fetching item with id: $id', error: e);
  }

  return null;
}


  static Future<void> create(
    nameController,
    notesController,
    imgController,
  ) async {
    final newItem = Item(
      name: nameController.text,
      notes: notesController.text,
      statusID: 1,
      categorieID: 1,
      availablity: true,
      rented: DateTime.now(),
      image: Uint8List(0),
    );
    // Insert the item into the database
    final id = await DatabaseHelper.instance.createItem(newItem);
    log('Inserted item with id: $id');
  }

 Future<void> save() async {
  // Ensure this item has an id (required for updating)
  if (id == null) {
    log('Error: Cannot save an item without an ID.');
    return;
  }

  // Create the updated item instance
  final updatedItem = Item(
    id: id, // Ensure the ID is set for updating
    name: name, // Use the updated name
    notes: notes, // Use the updated notes
    statusID: statusID, // Use the updated status ID
    categorieID: categorieID, // Use the updated category ID
    availablity: availablity, // Use the updated availability
    rented: rented, // Store the rented time
    image: image, // Keep the current image unless updated elsewhere
  );

  // Update the item in the database
  final rowsAffected = await DatabaseHelper.instance.createItem(updatedItem);

  log('Updated item with id: $id. Rows affected: $rowsAffected');
}

Future<void> delete() async {
  try {
    if (id != null) {
      // Create an Item instance and pass it to deleteItem method
      final item = Item(
        id: id,
        statusID: statusID,
        categorieID: categorieID,
        name: name,
        availablity: availablity,
        rented: rented,
        notes: notes,
        image: image,
      );

      // Use the database helper to delete the item
      final rowsAffected = await DatabaseHelper.instance.deleteItem(item);
      if (rowsAffected > 0) {
        log('Item with id $id successfully deleted.');
      } else {
        log('No item found with id $id.');
      }
    } else {
      log('Error: Item ID is null, cannot delete item.');
    }
  } catch (e) {
    log('Error deleting item with id $id', error: e);
  }
}

}
