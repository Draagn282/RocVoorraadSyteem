import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class Item {
  final int id;
  final int statusID; // Foreign key to the status table
  final int categorieID; // Foreign key to the categorie table
  final String name;
  final bool availablity; // Boolean indicating availability
  final String notes; // Additional notes about the item
  final String image; // URL or path to the item's image

  Item({
    required this.id,
    required this.statusID,
    required this.categorieID,
    required this.name,
    required this.availablity,
    required this.notes,
    required this.image,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      statusID: map['statusID'] as int,
      categorieID: map['categorieID'] as int,
      name: map['name'] as String,
      availablity: map['availablity'] ==
          1, // Assuming availability is stored as 0 or 1 in the database
      notes: map['notes'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statusID': statusID,
      'categorieID': categorieID,
      'name': name,
      'availablity': availablity ? 1 : 0, // Convert bool to int for storage
      'notes': notes,
      'image': image,
    };
  }

  static Future<Item?> getItem(int id) async {
    final data = await DatabaseHelper.instance.getData(
      tableName: 'item',
      whereClause: 'id = ' + id.toString(),
      whereArgs: [id],
    );

    if (data != null && data.isNotEmpty) {
      return Item.fromMap(data.first);
    }
    return null;
  }

  Future<void> save() async {
    // await DatabaseHelper.instance.updateData(
    //   tableName: 'items',
    //   values: this.toMap(),
    //   whereClause: 'id = ?',
    //   whereArgs: [this.id],
    // );
  }

  Future<void> delete() async {
    //   await DatabaseHelper.instance.deleteData(
    //     tableName: 'items',
    //     whereClause: 'id = ?',
    //     whereArgs: [this.id],
    //   );
  }
}
