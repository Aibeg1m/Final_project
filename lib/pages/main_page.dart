import 'package:flutter/material.dart';
import '../models/sport_section.dart';
import 'add_page.dart';
import 'filter_page.dart';
import 'home_screen.dart';
import 'profile_page.dart';
import 'video_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Set<String> selectedSports;
  List<SportSection> sports = [
    SportSection(title: "Football", query: "football"),
    SportSection(title: "Cricket", query: "cricket"),
    SportSection(title: "Hockey", query: "hockey"),
    SportSection(title: "Tennis", query: "tennis"),
    SportSection(title: "Volleyball", query: "volleyball"),
    SportSection(title: "Basketball", query: "basketball"),
    SportSection(title: "Baseball", query: "baseball"),
    SportSection(title: "Rugby", query: "rugby"),
    SportSection(title: "Golf", query: "golf"),
    SportSection(title: "CS2", query: "counter strike 2"),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSports = sports.map((e) => e.title).toSet();
  }


  int _currentIndex = 0;

  void addSport(SportSection section){
    setState(() {
      sports.add(section);
      selectedSports.add(section.title);
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        sports: sports,
        selectedSports: selectedSports,
      ),
      VideoPage(
        selectedSports: selectedSports,
      ),
      AddPage(onAdd: addSport),
      FilterPage(
          sports: sports,
          initialSelected: selectedSports,
          onApply: (result){
            setState(() {
              selectedSports = result;
              _currentIndex = 0;
            });
          }
      ),
      const ProfilePage(),
    ];
    return Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xFF163B63),
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFFFFFFFF),
            unselectedItemColor: const Color(0xFF7B8CA3),
            showUnselectedLabels: true,
            items:const[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "News"),
              BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Video"),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add news"),
              BottomNavigationBarItem(icon: Icon(Icons.filter_list), label: "Filter news"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ]
        )
    );
  }
}
