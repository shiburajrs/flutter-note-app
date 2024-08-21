import 'package:flutter/material.dart';
import 'package:notes_app/screens/homepage.dart';

import '../utils/text_style_utils.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset("assets/images/note.png",color: Colors.white,height: 120,),
            SizedBox(height: 20,),
            Text("Notes App",style: TextStyles.medium(color: Colors.white, fontSize: 35)),
        ],),
      ),
    );
  }
}
