import 'package:capcoin/screen/home_screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.white
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
        ),
        child:  Center(

          //Text area
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const  Text("Cap",

                style:TextStyle(fontSize: 35,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,


                ),
              ),
              //Text two Area
              Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                child: Text("Coin",
                  style:TextStyle(fontSize: 35,

                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),

        ),
      ),

    );
  }
}
