import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/main_screen.dart';


class MySplashScreen extends StatefulWidget
{
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen>
{

  startTimer()
  {
    // Vous pouvez également obtenir l'utilisateur actuellement connecté en utilisant la propriété "currentUser" .
    // Si un utilisateur n'est pas connecté, "currentUser" est null 

    // Si l'utilisateur est connecté, donner la possiblité de lire ses infos
    fAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;

    Timer(const Duration(seconds: 3), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    
    startTimer();
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset("images/logo_off.png"),

              const SizedBox(height: 10,),

              const Text(
                "Vite mon Chauffeur",
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
