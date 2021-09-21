import 'package:cookbook/models/users.dart';
import 'package:cookbook/screens/wrapper.dart';
import 'package:cookbook/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'CookBook',        
        theme: ThemeData(
          accentColor: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        debugShowCheckedModeBanner: false,        
        routes: {"/": (context) => Wrapper()},
        initialRoute: "/",
      ),
    );
  }
}

