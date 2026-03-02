import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/screens/second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(backScafoldColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 100,),
          //Image de bienvenue
          Padding(
            padding: const EdgeInsets.all(40),
            child:  Lottie.asset("assets/lotties/nuage.json",),
          ),
          //Image de bienvenue
          const Text(phrasedebienvenue,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: titleSize,
                fontFamily: family,
                fontWeight: FontWeight.bold
            ),
          ),

          //Espace entre le text et le bouton
          const SizedBox(height: 30,),

          //Bouton Demarrer
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffffffff)),
                minimumSize: MaterialStateProperty.all<Size>(Size(250,50))
            ),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context)=>const SecondScreen(),
                  )
              );
            },
            child: const Text(
              'Demarrer',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: buttonFontSize,
                  fontFamily: family
              ),
            ),
          )

        ],
      ),
    );
  }
}
