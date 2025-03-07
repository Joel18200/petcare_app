import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final List<Map<String, String>> _reminders = [
    {
      "title": "Vet Appointment",
      "time": "10:00 AM",
      "description": "Regular check-up for Bella"
    },
    {
      "title": "Grooming Session",
      "time": "2:00 PM",
      "description": "Spa day for Roudy"
    },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addReminder() {
    if (_titleController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        _reminders.add({
          "title": _titleController.text,
          "time": _timeController.text,
          "description": _descriptionController.text,
        });
        _titleController.clear();
        _timeController.clear();
        _descriptionController.clear();
      });
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Reminder", style: GoogleFonts.fredoka(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: GoogleFonts.fredoka(),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: "Time",
                  labelStyle: GoogleFonts.fredoka(),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: GoogleFonts.fredoka(),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: GoogleFonts.fredoka(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: _addReminder,
              child: Text("Add", style: GoogleFonts.fredoka()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders", style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _reminders.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  _reminders[index]["title"]!,
                  style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${_reminders[index]["time"]} - ${_reminders[index]["description"]}",
                  style: GoogleFonts.fredoka(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _reminders.removeAt(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
