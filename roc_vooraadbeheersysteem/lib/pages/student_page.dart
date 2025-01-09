// lib/pages/test/student_page.dart
import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';
import 'package:roc_vooraadbeheersysteem/helpers/database_helper.dart';
import 'package:roc_vooraadbeheersysteem/models/student_model.dart';

class StudentPage extends BasePage {
  const StudentPage({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          Text(
            'Students Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          StudentsTable(),
        ],
      ),
    );
  }
}

class StudentsTable extends StatefulWidget {
  const StudentsTable({Key? key}) : super(key: key);

  @override
  _StudentsTableState createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  final _searchController = TextEditingController();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final studentData = await DatabaseHelper.instance.getAllStudents();
    setState(() {
      _students = studentData.map((student) => Student.fromMap(student)).toList();
      _filteredStudents = List.from(_students);
    });
  }

  void _filterStudents() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        return student.name?.toLowerCase().contains(searchText) ?? false;
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
            labelText: 'Search Students by Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _filterStudents(),
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
                DataColumn(label: Text('Student ID')),
                DataColumn(label: Text('email')),
                DataColumn(label: Text('Class')),
                DataColumn(label: Text('Cohort')),
                DataColumn(label: Text('notes')),
                DataColumn(label: Text('')),
              ],
              rows: _filteredStudents.map((student) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(student.id.toString())),
                    DataCell(Text(student.name ?? '')),
                    DataCell(Text(student.studentID ?? '')),
                    DataCell(Text(student.email ?? '')),
                    DataCell(Text(student.studentClass ?? '')),
                    DataCell(Text(student.cohort ?? '')),
                    DataCell(Text(student.notes ?? '')),
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
