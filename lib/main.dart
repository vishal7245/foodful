import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodful/utils/colors.dart';
import 'package:provider/provider.dart';
import './responsive/responsive_layout_screen.dart';
import './responsive/web_screen_layout.dart';
import './responsive/mobile_screen_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/login_screens.dart';
import './screens/signup_screen.dart';
import 'Providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "AIzaSyAEOk3G5Czuus-7Unap-cAyKLmebe0Ik_g",
      appId: "1:1085680015658:web:2269d0819b9d1dd9d52653",
      messagingSenderId: "1085680015658",
      projectId: "foodful-2f799",
      storageBucket: "foodful-2f799.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FoodFul',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error'));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: pinkColor,
              ));
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
