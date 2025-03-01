// import "dart:io";

// import "package:cloud_firestore/cloud_firestore.dart";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hadja_grish/api/auth_api.dart";
import "package:hadja_grish/components/notification_service_local.dart";
import "package:hadja_grish/components/splash.dart";
import "package:hadja_grish/providers/auth_provider.dart";
import "package:hadja_grish/providers/cart_provider.dart";
import "package:hadja_grish/providers/favorite_provider.dart";
import "package:hadja_grish/providers/user_provider.dart";
import "package:hadja_grish/screens/auth/login_page.dart";
import 'package:provider/provider.dart';

import "package:timezone/data/latest.dart" as tz;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  final ServicesApiAuth apiAuth = ServicesApiAuth();
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  void setupFirebaseMessaging() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId(); // Attendre que userId soit résolu
    FirebaseMessaging.instance.getToken().then((token) async {
      print("Firebase Token: $token"); // À envoyer au backend
      try {
        final res = await apiAuth.postTokenFmcUser(userId, token);
        final body = jsonDecode(res.body);
        if (res.statusCode == 200) {
          print(body["message"]);
        }
      } catch (e) {
        print("erreur $e");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification reçue : ${message.notification?.title}");

      notificationService.showNotification(
              id: 1, // Convertir en int
              title: message.notification?.title,
              body: message.notification!.body ?? ""
            );
      
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification cliquée : ${message.notification?.title}");
    });
  }

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
