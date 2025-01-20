import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSlider extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSlider({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: screenWidth * 0.2, // Responsive height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 30, // Number of days to show in the slider
          itemBuilder: (context, index) {
            // Start from the current date
            final date = DateTime.now().add(Duration(days: index));
            final isSelected = widget.selectedDate != null &&
                date.year == widget.selectedDate!.year &&
                date.month == widget.selectedDate!.month &&
                date.day == widget.selectedDate!.day;

            return GestureDetector(
              onTap: () {
                widget.onDateSelected(date);
              },
              child: Container(
                width: screenWidth * 0.15, // Responsive width
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue[900]
                      : const Color.fromARGB(255, 226, 225, 225),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Date (e.g., 19, 20)
                    Text(
                      DateFormat('d').format(date), // Day of the month
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 17, 17, 17),
                      ),
                    ),
                    // Day name (e.g., Mon, Tue)
                    Text(
                      DateFormat('E').format(date), // Abbreviated day name
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // Responsive font size
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 17, 17, 17),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
