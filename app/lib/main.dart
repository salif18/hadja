// import "dart:io";

// import "package:cloud_firestore/cloud_firestore.dart";
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
// import "package:socket_io_client/socket_io_client.dart";
import "package:timezone/data/latest.dart" as tz;
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void setupFirebaseMessaging() {
  FirebaseMessaging.instance.getToken().then((token) {
    print("Firebase Token: $token"); // À envoyer au backend
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Notification reçue : ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification cliquée : ${message.notification?.title}");
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupFirebaseMessaging();


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
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final NotificationService notificationService = NotificationService();
  // late IO.Socket socket;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final provider = Provider.of<AuthProvider>(context, listen: false);
  //     final userId = await provider.userId(); // Attendre que userId soit résolu

  //     if (userId != null) {
        // Initialisation de la socket
        // socket = IO.io(
        //   "http://10.0.2.2:8080",
        //   IO.OptionBuilder()
        //       .setTransports(["websocket"])
        //       .setQuery({"userId": userId})
        //       .build(),
        // );

        // _connectToSocket();
  //       getNotifications(userId); // Passer userId résolu
  //     } else {
  //       print("Aucun userId trouvé");
  //     }
  //   });
  // }

  // void getNotifications(String userId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('notifications')
  //         .where('userId', isEqualTo: userId)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       for (var doc in querySnapshot.docs) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         print("Notification : ${data}");
  //         notificationService.showNotification(
  //             id: int.parse(data["orderId"]), // Convertir en int
  //             title: data["username"],
  //             body: data["message"]);
  //       }
  //     } else {
  //       print("Aucune notification trouvée pour l'utilisateur $userId");
  //     }
  //   } catch (e) {
  //     print("Erreur lors de la récupération des notifications: $e");
  //   }
  // }
  // Avec socket
  // Future<void> _connectToSocket() async {
  //   final provider = Provider.of<AuthProvider>(context, listen: false);
  //   final userId = await provider.userId();
  //   socket.onConnect((_) {
  //     print('Connecté au serveur WebSocket');
  //     socket.emit('join-room', userId);
  //   });

  //   socket.on("get-notification", (data) {
  //     print(data);
  //     notificationService.showNotification(
  //         id: data.orderId, title: data.username, body: data.message);
  //   });
  //   socket.onDisconnect((_) {
  //     print("Déconnecté du WebSocket");
  //   });

  //   socket.onConnectError((err) {
  //     print('Erreur de connexion WebSocket: $err');
  //   });

  //   socket.onError((err) {
  //     print('Erreur WebSocket: $err');
  //   });
  // }

  
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
