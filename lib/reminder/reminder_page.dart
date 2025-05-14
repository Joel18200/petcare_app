import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pawfect/utils/constants.dart';
import '../services/reminder_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _petNameController = TextEditingController();
  final _timeController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isAddLoading = false;
  bool _isEditLoading = false;
  bool _isDeleteLoading = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedPetType = 'Dog';
  bool _isPriority = false;
  Color _selectedColor = Colors.teal;
  String _searchQuery = '';

  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ReminderService.initNotifications();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _petNameController.dispose();
    _timeController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _selectedColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime.format(context);
      });
    }
  }

  DateTime _combineDateAndTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  Future<void> _addReminder() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a title'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isAddLoading = true);

    try {
      final DateTime scheduledDateTime = _combineDateAndTime();

      final reminderData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'petName': _petNameController.text,
        'time': _timeController.text,
        'date': scheduledDateTime.toIso8601String(),
        'petType': _selectedPetType,
        'isPriority': _isPriority,
        'color': _selectedColor.value,
        'completed': false,
        'createdAt': DateTime.now().toIso8601String(), // Added for sorting options
      };

      final id = await ReminderService.addReminder(reminderData);

      await ReminderService.scheduleReminderNotification(
        id: id.hashCode,
        title: reminderData['title'] as String,
        scheduledTime: scheduledDateTime,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Reminder added successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add reminder: $e'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isAddLoading = false);
    }
  }

  Future<void> _deleteReminder(String docId) async {
    setState(() => _isDeleteLoading = true);

    try {
      await ReminderService.deleteReminder(docId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text('Reminder deleted'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete reminder: $e'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isDeleteLoading = false);
    }
  }

  Future<void> _toggleReminderCompletion(String docId, bool currentStatus) async {
    try {
      await ReminderService.updateReminder(docId, {'completed': !currentStatus});

      // Show subtle feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentStatus ? 'Reminder marked as incomplete' : 'Reminder completed!'),
          duration: const Duration(seconds: 1),
          backgroundColor: currentStatus ? Colors.orange : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update reminder: $e'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editReminder(Map<String, dynamic> oldData, String docId) async {
    _titleController.text = oldData['title'];
    _descriptionController.text = oldData['description'] ?? '';
    _petNameController.text = oldData['petName'] ?? '';
    _timeController.text = oldData['time'] ?? '';
    _selectedPetType = oldData['petType'] ?? 'Dog';
    _selectedColor = Color(oldData['color']);
    _isPriority = oldData['isPriority'] ?? false;

    try {
      _selectedDate = DateTime.parse(oldData['date']);
      final time = oldData['time'] != null && oldData['time'].isNotEmpty
          ? TimeOfDay.fromDateTime(DateFormat.jm().parse(oldData['time']))
          : TimeOfDay.now();
      _selectedTime = time;
    } catch (e) {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Edit Pet Reminder",
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildReminderForm(isEdit: true),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() => _isEditLoading = true);

                        try {
                          final DateTime scheduledDateTime = _combineDateAndTime();

                          final updated = {
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'petName': _petNameController.text,
                            'time': _timeController.text,
                            'date': scheduledDateTime.toIso8601String(),
                            'petType': _selectedPetType,
                            'isPriority': _isPriority,
                            'color': _selectedColor.value,
                          };

                          await ReminderService.updateReminder(docId, updated);

                          await ReminderService.scheduleReminderNotification(
                            id: docId.hashCode,
                            title: updated['title'] as String,
                            scheduledTime: scheduledDateTime,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Reminder updated'),
                                ],
                              ),
                              backgroundColor: Colors.green.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );

                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update reminder: $e'),
                              backgroundColor: Colors.red.shade800,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } finally {
                          setState(() => _isEditLoading = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderForm({bool isEdit = false}) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title *',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _selectedColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _selectedColor, width: 2),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _petNameController,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    prefixIcon: const Icon(Icons.pets),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _selectedColor, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPetType,
                    onChanged: (val) => setState(() => _selectedPetType = val!),
                    items: ['Dog', 'Cat', 'Bird', 'Fish', 'Reptile', 'Other']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    icon: Icon(Icons.arrow_drop_down, color: _selectedColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(_selectedDate),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(Icons.calendar_today, color: _selectedColor),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: _selectedColor,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    prefixIcon: Icon(Icons.access_time, color: _selectedColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _selectedColor, width: 2),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminder Options",
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Priority: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: _isPriority,
                      onChanged: (val) => setState(() => _isPriority = val),
                      activeColor: Colors.red.shade600,
                      thumbColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => Colors.white,
                      ),
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    const Spacer(),
                    const Text(
                      "Color: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: _selectedColor,
                                onColorChanged: (color) => setState(() => _selectedColor = color),
                                pickerAreaHeightPercent: 0.8,
                                enableAlpha: false,
                                labelTypes: const [ColorLabelType.hex, ColorLabelType.rgb],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedColor.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> data, String docId) {
    final bool isCompleted = data['completed'] ?? false;
    final DateTime date = DateTime.parse(data['date']);
    final bool isOverdue = date.isBefore(DateTime.now()) && !isCompleted;
    final String timeString = data['time'] ?? '';

    return Dismissible(
      key: Key(docId),
      background: Container(
        color: Colors.red.shade600,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Reminder',
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            content: const Text('Are you sure you want to delete this reminder?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteReminder(docId),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(data['isPriority'] == true ? 0.4 : 0.2),
              blurRadius: data['isPriority'] == true ? 8 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: isCompleted
              ? Colors.grey.shade200
              : isOverdue
              ? Colors.red.shade50
              : Color(data['color']).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _editReminder(data, docId),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: data['isPriority'] == true
                    ? Border.all(color: Colors.red.shade400, width: 2)
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority indicator at the top
                  if (data['isPriority'] == true)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'PRIORITY',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet icon
                        Container(
                          decoration: BoxDecoration(
                            color: _getPetTypeColor(data['petType']).withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            _getPetTypeIcon(data['petType']),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['title'],
                                      style: GoogleFonts.fredoka(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                                        color: isCompleted ? Colors.grey : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: isCompleted,
                                    onChanged: (value) => _toggleReminderCompletion(docId, isCompleted),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    activeColor: Colors.green.shade600,
                                  ),
                                ],
                              ),
                              if (data['description'] != null && data['description'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                                  child: Text(
                                    data['description'],
                                    style: TextStyle(
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                      color: isCompleted ? Colors.grey : Colors.black54,
                                    ),
                                  ),
                                ),

                              // Pet info and date
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _getPetTypeIcon(data['petType']),
                                          size: 14,
                                          color: _getPetTypeColor(data['petType']),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${data['petName']} (${data['petType']})',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isCompleted ? Colors.grey : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: isOverdue ? Colors.red : Colors.black54,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat.yMMMd().format(date),
                                          style: TextStyle(
                                            color: isOverdue ? Colors.red : Colors.black54,
                                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        if (timeString.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: isOverdue ? Colors.red : Colors.black54,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            timeString,
                                            style: TextStyle(
                                              color: isOverdue ? Colors.red : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Edit button
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(data['color']).withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editReminder(data, docId),
                                color: Color(data['color']),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.shade100
                          : isOverdue
                          ? Colors.red.shade100
                          : Color(data['color']).withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isCompleted
                            ? 'COMPLETED'
                            : isOverdue
                            ? 'OVERDUE'
                            : 'ACTIVE',
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.green.shade700
                              : isOverdue
                              ? Colors.red.shade700
                              : Color(data['color']),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getPetTypeColor(String? petType) {
    switch (petType) {
      case 'Dog':
        return Colors.brown;
      case 'Cat':
        return Colors.orange;
      case 'Bird':
        return Colors.blue;
      case 'Fish':
        return Colors.lightBlue;
      case 'Reptile':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  IconData _getPetTypeIcon(String? petType) {
    switch (petType) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.pets;
      case 'Bird':
        return Icons.flutter_dash;
      case 'Fish':
        return Icons.water;
      case 'Reptile':
        return Icons.pest_control_rodent;
      default:
        return Icons.pets;
    }
  }

  // Sorting options
  String _sortBy = 'date';
  bool _sortAscending = true;

  Query _getSortedQuery(Query query) {
    switch (_sortBy) {
      case 'title':
        return query.orderBy('title', descending: !_sortAscending);
      case 'priority':
        return query.orderBy('isPriority', descending: !_sortAscending)
            .orderBy('date', descending: false);
      case 'pet':
        return query.orderBy('petType', descending: !_sortAscending)
            .orderBy('petName', descending: !_sortAscending);
      case 'created':
        return query.orderBy('createdAt', descending: !_sortAscending);
      case 'date':
      default:
        return query.orderBy('date', descending: !_sortAscending);
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Sort Reminders",
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSortOption(
                    'date',
                    'Date',
                    Icons.calendar_today,
                    setModalState,
                  ),
                  _buildSortOption(
                    'title',
                    'Title',
                    Icons.sort_by_alpha,
                    setModalState,
                  ),
                  _buildSortOption(
                    'priority',
                    'Priority',
                    Icons.star,
                    setModalState,
                  ),
                  _buildSortOption(
                    'pet',
                    'Pet Type',
                    Icons.pets,
                    setModalState,
                  ),
                  _buildSortOption(
                    'created',
                    'Date Created',
                    Icons.access_time,
                    setModalState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
      String value, String label, IconData icon, StateSetter setModalState) {
    return ListTile(
      leading: Icon(icon, color: _sortBy == value ? Colors.teal : Colors.grey),
      title: Text(label),
      trailing: _sortBy == value
          ? Icon(
        _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
        color: Colors.teal,
      )
          : null,
      selected: _sortBy == value,
      selectedColor: Colors.teal,
      onTap: () {
        setModalState(() {
          if (_sortBy == value) {
            _sortAscending = !_sortAscending;
          } else {
            _sortBy = value;
            _sortAscending = true;
          }
        });

        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Pet Reminders',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        elevation: 30,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, greenColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort Reminders',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // You can add notification settings here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings will be added soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Notification Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reminders...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: Colors.grey.shade50,
                filled: true,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Reminders Tab
                StreamBuilder<QuerySnapshot>(
                  stream: _getSortedQuery(
                      FirebaseFirestore.instance.collection('reminders')
                  ).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState('No reminders yet', 'Add your first pet reminder!');
                    }

                    final reminders = snapshot.data!.docs;
                    final filteredReminders = reminders.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final String title = data['title'] ?? '';
                      final String description = data['description'] ?? '';
                      final String petName = data['petName'] ?? '';
                      final String petType = data['petType'] ?? '';

                      return _searchQuery.isEmpty ||
                          title.toLowerCase().contains(_searchQuery) ||
                          description.toLowerCase().contains(_searchQuery) ||
                          petName.toLowerCase().contains(_searchQuery) ||
                          petType.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (filteredReminders.isEmpty) {
                      return _buildEmptyState('No matching reminders', 'Try a different search term');
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredReminders.length,
                      itemBuilder: (context, index) {
                        final doc = filteredReminders[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final docId = doc.id;

                        return _buildReminderCard(data, docId);
                      },
                    );
                  },
                ),

                // Upcoming Reminders Tab
                StreamBuilder<QuerySnapshot>(
                  stream: _getSortedQuery(
                      FirebaseFirestore.instance.collection('reminders')
                  ).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState('No upcoming reminders', 'All completed! Great job!');
                    }

                    final reminders = snapshot.data!.docs;
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);

                    final filteredReminders = reminders.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final bool completed = data['completed'] ?? false;

                      // Skip completed reminders
                      if (completed) return false;

                      // Check if it matches search
                      final String title = data['title'] ?? '';
                      final String description = data['description'] ?? '';
                      final String petName = data['petName'] ?? '';
                      final String petType = data['petType'] ?? '';

                      final bool matchesSearch = _searchQuery.isEmpty ||
                          title.toLowerCase().contains(_searchQuery) ||
                          description.toLowerCase().contains(_searchQuery) ||
                          petName.toLowerCase().contains(_searchQuery) ||
                          petType.toLowerCase().contains(_searchQuery);

                      if (!matchesSearch) return false;

                      // Check if it's an upcoming date (today or future)
                      try {
                        final DateTime date = DateTime.parse(data['date']);
                        final reminderDate = DateTime(date.year, date.month, date.day);
                        return reminderDate.compareTo(today) >= 0; // Today or future
                      } catch (e) {
                        return false; // Invalid date format
                      }
                    }).toList();

                    if (filteredReminders.isEmpty) {
                      return _buildEmptyState('No upcoming reminders', 'All completed or no future reminders!');
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredReminders.length,
                      itemBuilder: (context, index) {
                        final doc = filteredReminders[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final docId = doc.id;

                        return _buildReminderCard(data, docId);
                      },
                    );
                  },
                ),

                // Completed Reminders Tab
                StreamBuilder<QuerySnapshot>(
                  stream: _getSortedQuery(
                      FirebaseFirestore.instance.collection('reminders')
                  ).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState('No completed reminders', 'Complete a task to see it here!');
                    }

                    final reminders = snapshot.data!.docs;
                    final filteredReminders = reminders.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final bool completed = data['completed'] ?? false;

                      // Skip non-completed reminders
                      if (!completed) return false;

                      // Check if it matches search
                      final String title = data['title'] ?? '';
                      final String description = data['description'] ?? '';
                      final String petName = data['petName'] ?? '';
                      final String petType = data['petType'] ?? '';

                      return _searchQuery.isEmpty ||
                          title.toLowerCase().contains(_searchQuery) ||
                          description.toLowerCase().contains(_searchQuery) ||
                          petName.toLowerCase().contains(_searchQuery) ||
                          petType.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (filteredReminders.isEmpty) {
                      return _buildEmptyState('No matching completed reminders', 'Try a different search term');
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredReminders.length,
                      itemBuilder: (context, index) {
                        final doc = filteredReminders[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final docId = doc.id;

                        return _buildReminderCard(data, docId);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _titleController.clear();
          _descriptionController.clear();
          _petNameController.clear();
          _timeController.clear();
          _selectedDate = DateTime.now();
          _selectedTime = TimeOfDay.now();
          _isPriority = false;
          _selectedColor = Colors.teal;
          _selectedPetType = 'Dog';

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _selectedColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "New Pet Reminder",
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildReminderForm(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addReminder,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _selectedColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text("Add Reminder"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        label: const Text("Add Reminder"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}