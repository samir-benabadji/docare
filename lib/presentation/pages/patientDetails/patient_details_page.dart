import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  String _selectedGender = 'Gender';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
        leading: BackButton(),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Full Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Phone Number',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender != 'Gender' ? _selectedGender : null,
              hint: Text('Gender'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: <String>['Man', 'Woman'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _problemController,
              decoration: InputDecoration(
                labelText: 'Write your problem',
                hintText: 'Tell the doctor about your problem',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Continue'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
