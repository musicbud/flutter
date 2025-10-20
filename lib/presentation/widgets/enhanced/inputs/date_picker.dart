import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Date and time picker components for user input
/// 
/// This file provides reusable date/time selection widgets:
/// - DatePickerField: Text field with date picker
/// - TimePickerField: Text field with time picker
/// - DateTimePickerField: Combined date and time picker
/// - BirthdayPicker: Specialized birthday selection
/// - AgePicker: Age selection with calculated date

/// A text field that opens a date picker when tapped
/// 
/// Perfect for birthday selection, event dates, scheduling.
/// 
/// Example:
/// ```dart
/// DatePickerField(
///   label: 'Select Date',
///   selectedDate: _date,
///   onDateSelected: (date) => setState(() => _date = date),
///   firstDate: DateTime(1900),
///   lastDate: DateTime.now(),
/// )
/// ```
class DatePickerField extends StatelessWidget {
  /// Label for the field
  final String label;
  
  /// Currently selected date
  final DateTime? selectedDate;
  
  /// Callback when date is selected
  final ValueChanged<DateTime> onDateSelected;
  
  /// First selectable date
  final DateTime firstDate;
  
  /// Last selectable date
  final DateTime lastDate;
  
  /// Date format (defaults to 'MMM dd, yyyy')
  final String Function(DateTime)? dateFormatter;
  
  /// Field decoration
  final InputDecoration? decoration;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Icon to display
  final IconData icon;

  const DatePickerField({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.dateFormatter,
    this.decoration,
    this.enabled = true,
    this.icon = Icons.calendar_today,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: enabled ? () => _showDatePicker(context) : null,
      child: InputDecorator(
        decoration: decoration ??
            InputDecoration(
              labelText: label,
              suffixIcon: Icon(icon),
              border: const OutlineInputBorder(),
            ),
        child: Text(
          selectedDate != null
              ? _formatDate(selectedDate!)
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null
                ? theme.textTheme.bodyLarge?.color
                : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      onDateSelected(date);
    }
  }

  String _formatDate(DateTime date) {
    if (dateFormatter != null) {
      return dateFormatter!(date);
    }
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

/// A text field that opens a time picker when tapped
/// 
/// Perfect for scheduling, reminders, appointments.
/// 
/// Example:
/// ```dart
/// TimePickerField(
///   label: 'Select Time',
///   selectedTime: _time,
///   onTimeSelected: (time) => setState(() => _time = time),
/// )
/// ```
class TimePickerField extends StatelessWidget {
  /// Label for the field
  final String label;
  
  /// Currently selected time
  final TimeOfDay? selectedTime;
  
  /// Callback when time is selected
  final ValueChanged<TimeOfDay> onTimeSelected;
  
  /// Field decoration
  final InputDecoration? decoration;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Icon to display
  final IconData icon;
  
  /// Use 24-hour format
  final bool use24HourFormat;

  const TimePickerField({
    super.key,
    required this.label,
    this.selectedTime,
    required this.onTimeSelected,
    this.decoration,
    this.enabled = true,
    this.icon = Icons.access_time,
    this.use24HourFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: enabled ? () => _showTimePicker(context) : null,
      child: InputDecorator(
        decoration: decoration ??
            InputDecoration(
              labelText: label,
              suffixIcon: Icon(icon),
              border: const OutlineInputBorder(),
            ),
        child: Text(
          selectedTime != null
              ? selectedTime!.format(context)
              : 'Select time',
          style: TextStyle(
            color: selectedTime != null
                ? theme.textTheme.bodyLarge?.color
                : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: use24HourFormat,
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      onTimeSelected(time);
    }
  }
}

/// Combined date and time picker field
/// 
/// Perfect for event scheduling, appointments.
/// 
/// Example:
/// ```dart
/// DateTimePickerField(
///   label: 'Event Date & Time',
///   selectedDateTime: _dateTime,
///   onDateTimeSelected: (dt) => setState(() => _dateTime = dt),
/// )
/// ```
class DateTimePickerField extends StatefulWidget {
  /// Label for the field
  final String label;
  
  /// Currently selected date/time
  final DateTime? selectedDateTime;
  
  /// Callback when date/time is selected
  final ValueChanged<DateTime> onDateTimeSelected;
  
  /// First selectable date
  final DateTime firstDate;
  
  /// Last selectable date
  final DateTime lastDate;
  
  /// Field decoration
  final InputDecoration? decoration;
  
  /// Whether field is enabled
  final bool enabled;

  const DateTimePickerField({
    super.key,
    required this.label,
    this.selectedDateTime,
    required this.onDateTimeSelected,
    required this.firstDate,
    required this.lastDate,
    this.decoration,
    this.enabled = true,
  });

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: widget.enabled ? _showDateTimePicker : null,
      child: InputDecorator(
        decoration: widget.decoration ??
            InputDecoration(
              labelText: widget.label,
              suffixIcon: const Icon(Icons.event),
              border: const OutlineInputBorder(),
            ),
        child: Text(
          widget.selectedDateTime != null
              ? _formatDateTime(widget.selectedDateTime!)
              : 'Select date and time',
          style: TextStyle(
            color: widget.selectedDateTime != null
                ? theme.textTheme.bodyLarge?.color
                : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    // First pick date
    final date = await showDatePicker(
      context: context,
      initialDate: widget.selectedDateTime ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (date == null) return;

    if (!mounted) return;

    // Then pick time
    final time = await showTimePicker(
      context: context,
      initialTime: widget.selectedDateTime != null
          ? TimeOfDay.fromDateTime(widget.selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (time != null) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      widget.onDateTimeSelected(dateTime);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_monthName(dateTime.month)} ${dateTime.day}, ${dateTime.year} at ${_formatTime(dateTime)}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final displayHour = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
  }
}

/// Specialized birthday picker with age calculation
/// 
/// Perfect for user registration, profile creation.
/// 
/// Example:
/// ```dart
/// BirthdayPicker(
///   selectedDate: _birthday,
///   onDateSelected: (date) => setState(() => _birthday = date),
///   minimumAge: 13, // Must be at least 13 years old
/// )
/// ```
class BirthdayPicker extends StatelessWidget {
  /// Currently selected birthday
  final DateTime? selectedDate;
  
  /// Callback when birthday is selected
  final ValueChanged<DateTime> onDateSelected;
  
  /// Minimum age requirement
  final int? minimumAge;
  
  /// Maximum age (default 120)
  final int maximumAge;
  
  /// Field decoration
  final InputDecoration? decoration;

  const BirthdayPicker({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.minimumAge,
    this.maximumAge = 120,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastDate = minimumAge != null
        ? DateTime(now.year - minimumAge!, now.month, now.day)
        : now;
    final firstDate = DateTime(now.year - maximumAge, 1, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DatePickerField(
          label: 'Birthday',
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
          firstDate: firstDate,
          lastDate: lastDate,
          decoration: decoration,
          icon: Icons.cake,
        ),
        if (selectedDate != null) ...[
          const SizedBox(height: 8),
          Text(
            'Age: ${_calculateAge(selectedDate!)} years old',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

/// Age picker with year selection
/// 
/// Perfect for quick age selection without full date.
/// 
/// Example:
/// ```dart
/// AgePicker(
///   selectedAge: _age,
///   onAgeSelected: (age) => setState(() => _age = age),
///   minAge: 18,
///   maxAge: 99,
/// )
/// ```
class AgePicker extends StatelessWidget {
  /// Currently selected age
  final int? selectedAge;
  
  /// Callback when age is selected
  final ValueChanged<int> onAgeSelected;
  
  /// Minimum selectable age
  final int minAge;
  
  /// Maximum selectable age
  final int maxAge;
  
  /// Field label
  final String label;
  
  /// Field decoration
  final InputDecoration? decoration;

  const AgePicker({
    super.key,
    this.selectedAge,
    required this.onAgeSelected,
    this.minAge = 13,
    this.maxAge = 99,
    this.label = 'Age',
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showAgePicker(context),
      child: InputDecorator(
        decoration: decoration ??
            InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: const OutlineInputBorder(),
            ),
        child: Text(
          selectedAge != null ? '$selectedAge years old' : 'Select age',
          style: TextStyle(
            color: selectedAge != null
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _showAgePicker(BuildContext context) async {
    final ages = List.generate(maxAge - minAge + 1, (i) => minAge + i);
    final initialIndex = selectedAge != null
        ? selectedAge! - minAge
        : (ages.length / 2).floor();

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select Age',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    onAgeSelected(ages[index]);
                  },
                  children: ages.map((age) {
                    return Center(
                      child: Text(
                        '$age years old',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
