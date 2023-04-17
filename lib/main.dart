import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunftmobilev3/pages/Login.dart';
import 'package:sunftmobilev3/pages/MainApplication.dart';
import 'package:sunftmobilev3/pages/Register.dart';
import 'package:sunftmobilev3/providers/UserProvider.dart';
import 'package:sunftmobilev3/providers/ethereumProvider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EthereumProvider())
      ],
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/Login",
      routes: {
        "/Login": (context) => const Login(),
        "/Register":(context)  =>  Register(),
        "/MainPage":(context) => MainPage(),
      },
    );
  }
}