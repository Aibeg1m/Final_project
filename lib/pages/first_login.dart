import 'package:flutter/material.dart';

class FirstLogin extends StatelessWidget {
  const FirstLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/photo_log_first.jpg", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 100),
                  alignment: Alignment.center,
                  width: 450,
                  child: Text(
                    "Welcome to my Final project!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFFE6EAF0),
                      fontFamily: 'Popins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  width: 250,
                  child: Text(
                    "This project is not perfect, but I use my brain fully. So next u can see my work.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB8C4D6),
                      fontSize: 14,
                      height: 1.4,
                      fontFamily: 'Popins',
                    ),
                  )

                ),

                SizedBox(height: 400),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signIn');
                        },
                        child: Text("Sign in",style: TextStyle(color: Colors.white,fontFamily: 'Popins',fontSize: 14),),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 50),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        child: Text("Sign up",style: TextStyle(color: Colors.white,fontFamily: 'Popins',fontSize: 14),
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
}
