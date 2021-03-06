import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{
  const LoginScreen({Key? key}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


// _________________________message FlutterToast Deuxieme methode
late FToast fToast;

@override
void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
}
String? message;

// j'ai dû créer une fonction _showToast avec pour paramètres message que j'appelle a chaque fois
_showToast({required String message}) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            const SizedBox(
            width: 12.0,
            ),
            Text(message,),
        ],
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
    );
    
}
// ________________________



  validateForm()
  {
    if(!emailTextEditingController.text.contains("@"))
    {
      _showToast(message: "Email non valid.");
    }
    else if(passwordTextEditingController.text.isEmpty)
    {
      _showToast(message: "Mot de pass exigé.");
    }
    else
    {
      loginUserNow();
    }
  }

  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Veuillez patientez...",);
        }
    ); 
 
    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          // _showToast(message: "Error: " + msg.toString());
          _showToast(message: "Verifier que les identifiants soit corrects !");
        })
    ).user;

    if(firebaseUser != null)
    {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).once().then((driverKey)
      {
        final snap = driverKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          // _showToast(message: "Login Successful.");Pas neccessaire
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
        else
        {
          _showToast(message: "Aucun utilisateur ne correspond a ces identifiants !");
          // deconnexion
          fAuth.signOut();
          // redirection
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      _showToast(message: "Erreur de connexion.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo_off.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                // "Login as a User",
                "Se connecter",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1A237E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1A237E)),
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 14,
                  ),
                ),
              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Mot de pass",
                  hintText: "Mot de pass",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1A237E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1A237E)),
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: ()
                {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFF57F17),
                ),
                child: const Text(
                  "Connexion",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),

              TextButton(
                child: const Text(
                  "Vous n'avez pas de compte ? Inscrivez vous",
                  style: TextStyle(color: Color(0xFF1A237E)),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const SignUpScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
