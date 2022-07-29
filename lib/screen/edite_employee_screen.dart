import 'package:flutter/material.dart';
import 'package:test_sql/db/app_db.dart';
import 'package:test_sql/widgets/custom_picker_form_field.dart';
import 'package:test_sql/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

class EditEmployeeScreen extends StatefulWidget {
  final int id;

  const EditEmployeeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late AppDb _db;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOdBirthController = TextEditingController();
  DateTime? _dateOfBirth;
  late EmployeeData _employeeData;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
    getEmployee();
  }

  @override
  void dispose() {
    _db.close();
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOdBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              editEmployee();
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              deleteEmployee();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _userNameController,
              labelText: 'User Name',
            ),
            const SizedBox(height: 8.0),
            CustomTextFormField(
              controller: _firstNameController,
              labelText: 'First Name',
            ),
            const SizedBox(height: 8.0),
            CustomTextFormField(
              controller: _lastNameController,
              labelText: 'Last Name',
            ),
            const SizedBox(height: 8.0),
            CustomDatePickerFormField(
              controller: _dateOdBirthController,
              labelText: 'Date of Birth',
              callback: () {
                pickDateBirth(context);
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Future<void> pickDateBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              onSurface: Colors.black26,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const Text('Error')),
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      _dateOfBirth = newDate;
      String dob = DateFormat('dd/MM/yyyy').format(newDate);
      _dateOdBirthController.text = dob;
    });
  }

  void editEmployee() {
    final entity = EmployeeCompanion(
      id: drift.Value(widget.id),
      userName: drift.Value(_userNameController.text),
      firstName: drift.Value(_firstNameController.text),
      lastName: drift.Value(_lastNameController.text),
      dateOfBirth: drift.Value(_dateOfBirth!),
    );
    _db.updateEmployee(entity).then(
          (value) => ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.pink,
              content: Text(
                'Employee Update: $value',
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                ),
              ],
            ),
          ),
        );
  }

  Future<void> getEmployee() async {
    _employeeData = await _db.getEmployee(widget.id);
    _userNameController.text = _employeeData.userName;
    _firstNameController.text = _employeeData.firstName;
    _lastNameController.text = _employeeData.lastName;
    _dateOdBirthController.text = _employeeData.dateOfBirth.toIso8601String();
  }

  void deleteEmployee() {
    _db.deleteEmployee(widget.id).then(
          (value) => ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.pink,
              content: Text('Employee Deleted: $value',
                  style: const TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  child: const Text('Close', style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                ),
              ],
            ),
          ),
        );
  }
}
