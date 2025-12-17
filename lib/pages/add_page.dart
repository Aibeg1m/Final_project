import 'package:final_project/models/sport_section.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class AddPage extends StatefulWidget {
  final void Function(SportSection section) onAdd;

  const AddPage({super.key, required this.onAdd});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController titleAdd = TextEditingController();
  final TextEditingController queryAdd = TextEditingController();

  void submit() {
    final title = titleAdd.text.trim();
    final query = queryAdd.text.trim();

    if (title.isEmpty || query.isEmpty) {
      return;
    }

    widget.onAdd(SportSection(title: title, query: query));
    titleAdd.clear();
    queryAdd.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add page',
          style: TextStyle(color: Color(0xFFE6EAF0), fontSize: 20),
        ),
        backgroundColor: Color(0xFF163B63),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'In this page you can add your news. \nJust input title of news and query.',
                      style: TextStyle(fontSize: 14, fontFamily: 'Poppins',color: Color(0xFFE6EAF0)),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      'Title',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14,color: Color(0xFFE6EAF0)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleAdd,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.newspaper),
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        hintText: 'Enter title of news',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Query',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14,color: Color(0xFFE6EAF0)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: queryAdd,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        prefixIcon: const Icon(Icons.query_stats),
                        hintText: 'Enter query of news',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B8DEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Login',style: TextStyle(color: Color(0xFFE6EAF0)),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
