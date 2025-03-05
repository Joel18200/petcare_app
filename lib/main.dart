import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawfect/login/login.dart';
import 'package:pawfect/pet_health/pet_health.dart';
import 'package:pawfect/screens/getting_started.dart';
import 'package:pawfect/screens/home/dashboard.dart';
import 'package:pawfect/signup/signup.dart';
import 'package:pawfect/utils/constants.dart';

void main()
{
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Colors.black,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.white,
        useMaterial3: false,
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}

final _router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
  ),
  GoRoute(
    name: loginRoute,
    path: loginRoute,
    builder: (context, state) => const Login(),
  ),
  GoRoute(
    name: dashboardRoute,
    path: dashboardRoute,
    builder: (context, state) => const Dashboard(),
  ),
  GoRoute(
    name: signupRoute,
    path: signupRoute,
    builder: (context, state) => const Signup(),
  ),
  GoRoute(
    name: petHealthRoute,
    path: petHealthRoute,
    builder: (context, state) => const PetHealth(),
  ),
  GoRoute(
    name: petHealthRoute,
    path: petHealthRoute,
    builder: (context, state) => const PetHealth(),
  ),
  GoRoute(
    name: petHealthRoute,
    path: petHealthRoute,
    builder: (context, state) => const PetHealth(),
  )
]);

