import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/progress_dialog.dart';


class SignUpScreen extends StatefulWidget
{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
    if(nameTextEditingController.text.length < 3)
    {
      _showToast(message: "3 caracteres exigés pour le nom.");
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      _showToast(message: "Email pas valid.");
    }
    else if(phoneTextEditingController.text.isEmpty)
    {
      _showToast(message: "numero exigé.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      _showToast(message: "Mot de pass exigeant 6 caracteres");
    }
    else
    {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async
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
      // await FirebaseAuth.instance.createUserWithEmailAndPassword /Similaire
      await fAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ).catchError((msg){
        Navigator.pop(context);
        // print("Error: " + msg.toString());
        _showToast(message: "Mail associé a un autre compte");

      })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      // 'driversRef'=>la reference de la base de donnée, peut prendre un nom different (usersRef)
      // "FirebaseDatabase.instance.ref().child("users")" => la ou nous enregistrons nos données
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      // _showToast(message: "Account has been Created.");pas neccessaire
      // apres creation du compte redirection vers la connexion
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
    }
    else
    {
      Navigator.pop(context);
      _showToast(message: "Erreur de creation de compte.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo_off.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "S'enregistrer",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Nom",
                  hintText: "Nom",
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Telephone",
                  hintText: "Telephone",
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
                  "Valider",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),

              TextButton(
                child: const Text(
                  "Deja un compte? Connectez vous",
                  style: TextStyle(color: Color(0xFF1A237E)),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
