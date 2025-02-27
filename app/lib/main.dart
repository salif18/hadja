import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hadja_grish/components/notification_service_local.dart";
import "package:hadja_grish/components/splash.dart";
import "package:hadja_grish/providers/auth_provider.dart";
import "package:hadja_grish/providers/cart_provider.dart";
import "package:hadja_grish/providers/favorite_provider.dart";
import "package:hadja_grish/providers/user_provider.dart";
import "package:hadja_grish/screens/auth/login_page.dart";
import 'package:provider/provider.dart';
import "package:socket_io_client/socket_io_client.dart";
import "package:timezone/data/latest.dart" as tz;
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => UserInfosProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => FavoriteProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 final NotificationService notificationService = NotificationService();
   late IO.Socket socket;
   
  @override
  void initState() {
    super.initState();
    _connectToSocket();
  }

   Future<void> _connectToSocket() async {
  final provider = Provider.of<AuthProvider>(context, listen: false);
  final userId = await provider.userId();  // Assure-toi que userId est bien récupéré
  
  if (userId == null || userId.isEmpty) {
    print("Erreur : userId est null ou vide !");
    return;
  }

  socket = IO.io("https://hadja-store-node.vercel.app/api");
  //  {
  //   'transports': ['websocket'],
  //   'autoConnect': true,
  //   'query': {'userId': userId}
  // });

  socket.onConnect((_) {
    print("Connexion WebSocket réussie !");
    // socket.emit('join-room', userId);
  });

  socket.on("nouvelle-notification", (data){
    print(data);
    notificationService.showNotification(
      id:data.orderId,
      title:data.userId,
      body:data.message
    );
    });
}


  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Longrish",
      home: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<String?>(
            future: provider.token(),
            builder: (context, snapshot) {
              final token = snapshot.data;
              if (token != null && token.isNotEmpty) {
                return const MySplashScreen();
              } else {
                return const LoginPage();
              }
            },
          );
        },
      ),
    );
  }
}
