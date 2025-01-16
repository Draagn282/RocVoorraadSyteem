import 'dart:developer';

import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';

class Student {
  final int id;
  final String name; // Student's full name
  final String studentID; // Unique student identifier
  final String email; // Student's email
  final String studentClass; // Class the student belongs to
  final String cohort; // Student's date of birth
  final String notes; // Additional notes about the student

  Student({
    required this.id,
    required this.name,
    required this.studentID,
    required this.email,
    required this.studentClass,
    required this.cohort,
    required this.notes,
  });

  // Named constructor to create a Student from a Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      name: map['name'] as String? ?? '', // Use empty string if null
      studentID: map['studentID'] as String? ?? '', // Use empty string if null
      email: map['email'] as String? ?? '', // Use empty string if null
      studentClass: map['studentClass'] as String? ?? '', // Use empty string if null
      cohort: map['cohort'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }

  // Method to convert a Student to a Map (for database insertions or updates)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentID': studentID,
      'email': email,
      'studentClass': studentClass,
      'dateOfBirth': cohort,
      'notes': notes,
    };
  }

  // Fetch a specific student by ID
  static Future<Student?> getStudent(int id) async {
    try {
      // Log the function call
      log('Fetching student with id: $id');

      // Get data from the database
      final data = await DatabaseHelper.instance.getData(
        tableName: 'student',
        whereClause: 'id = ?',
        whereArgs: [id],

      );

      // Check if data is retur ned
      if (data != null && data.isNotEmpty) {
        return Student.fromMap(data.first);
      } else {
        log('No student found with id: $id');
      }
    } catch (e) {
      // Log any errors encountered
      log('Error fetching student with id: $id', error: e);
    }

    // Return null if no data is found or an error occurs
    return null;
  }

  // Save the student (insert or update in the database)
 Future<void> save() async {
  try {
    log('Saving student: $name');
    await DatabaseHelper.instance.insertOrUpdate(
      tableName: 'student',
      data: toMap(),
      whereClause: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    log('Error saving student: $name', error: e);
  }
}

  // Delete the student from the database
Future<void> delete() async {
  try {
    log('Deleting student with id: $id');
    await DatabaseHelper.instance.delete(
      tableName: 'student',
      whereClause: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    log('Error deleting student with id: $id', error: e);
  }
}
}
