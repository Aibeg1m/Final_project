import 'package:flutter/material.dart';
import '../models/sport_section.dart';

class FilterPage extends StatefulWidget {
  final List<SportSection> sports;
  final Set<String> initialSelected;
  final void Function(Set<String>) onApply;

  const FilterPage({
    super.key,
    required this.onApply,
    required this.initialSelected,
    required this.sports,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late Set<String> selectedSports;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSports = Set.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter page", style: TextStyle(color: Color(0xFFE6EAF0))),
        backgroundColor: Color(0xFF163B63),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter Sports",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xFFE6EAF0)),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.sports.map((sport) {
                    final selected = selectedSports.contains(sport.title);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected
                              ? selectedSports.remove(sport.title)
                              : selectedSports.add(sport.title);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          sport.title,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B8DEF),
                    ),
                    onPressed: () {
                      widget.onApply(selectedSports);
                    },

                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Color(0xFFE6EAF0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
