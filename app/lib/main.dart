import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  tz.initializeTimeZones();
  runApp(MultiProvider(
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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService notificationService = NotificationService();
  late IO.Socket socket;

  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = provider.userId();

    // Initialisation de la socket
    socket = IO.io(
      "http://10.0.2.2:8080",
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .setQuery({"userId": userId})
          .build(),
    );

    _connectToSocket();
    getNotifications(userId.toString());
  });
}

  void getNotifications(String userId) {
    _firestore
        .collection('notifications')
        .get()
        .then((querySnapshot) {
      // Parcourir chaque document dans le QuerySnapshot
      for (var doc in querySnapshot.docs) {
        // Accéder aux données du document
        print(doc.data());
        // Appeler showNotification avec les données du document
        notificationService.showNotification(
          id: doc[
              'orderId'], // Assurez-vous que 'orderId' existe dans le document
          title: doc[
              'username'], // Assurez-vous que 'username' existe dans le document
          body: doc[
              'message'], // Assurez-vous que 'message' existe dans le document
        );
      }
    }).catchError((error) {
      // Gérer les erreurs
      print("Erreur lors de la récupération des notifications: $error");
    });
  }

  Future<void> _connectToSocket() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    socket.onConnect((_) {
      print('Connecté au serveur WebSocket');
      socket.emit('join-room', userId);
    });

    socket.on("get-notification", (data) {
      print(data);
      notificationService.showNotification(
          id: data.orderId, title: data.username, body: data.message);
    });
    socket.onDisconnect((_) {
      print("Déconnecté du WebSocket");
    });

    socket.onConnectError((err) {
      print('Erreur de connexion WebSocket: $err');
    });

    socket.onError((err) {
      print('Erreur WebSocket: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
