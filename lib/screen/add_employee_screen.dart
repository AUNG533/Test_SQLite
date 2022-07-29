import 'package:flutter/material.dart';
import 'package:test_sql/db/app_db.dart';
import 'package:test_sql/widgets/custom_picker_form_field.dart';
import 'package:test_sql/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {

  final _formKey = GlobalKey<FormState>();

  late AppDb _db;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOdBirthController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
  }

  @override
  void dispose() {
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
        title: const Text('Add Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              addEmployee();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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

  void addEmployee() {
    final isValid = _formKey.currentState?.validate();
    final entity = EmployeeCompanion(
      userName: drift.Value(_userNameController.text),
      firstName: drift.Value(_firstNameController.text),
      lastName: drift.Value(_lastNameController.text),
      dateOfBirth: drift.Value(_dateOfBirth!),
    );
    _db.insertEmployee(entity).then(
          (value) => ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.pink,
              content: Text(
                'New employee inserted: $value',
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
}
