import 'dart:developer';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

  class Status {
  final int id;
  final String name;

  Status({
     required this.id,
     required this.name
    });

  // Map database result to Category object
  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      name: map['name'],
    );
  }

  // Map Category object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Future<Status?> getCategory(int id) async {
    try {
      // Log the function call
      log('Fetching item with id: $id');

      // Get data from the database
      final data = await DatabaseHelper.instance.getData(
        tableName: 'item',
        whereClause: 'id = 1', // Use placeholder for safety
        whereArgs: [id],
      );

      // Check if data is returned
      if (data != null && data.isNotEmpty) {
        return Status.fromMap(data.first);
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
