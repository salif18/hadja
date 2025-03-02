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
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    await setupFirebaseMessaging();
  }

  Future<void> setupFirebaseMessaging() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    
    String? userId = await provider.userId();
    if (userId == null || userId.trim().isEmpty) {
      print("Impossible d'envoyer le token, userId est null ou vide.");
      return;
    }

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) {
        print("Impossible d'envoyer le token, Firebase n'a pas généré de token.");
        return;
      }

      print("Firebase Token: $token");

      final res = await apiAuth.postTokenFmcUser(userId, token);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print("Token enregistré avec succès : ${body["message"]}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi du token FCM : $e");
    }

    // Écoute des notifications en mode foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title ?? message.data["title"];
      String? body = message.notification?.body ?? message.data["body"];

      if (title != null && body != null) {
        notificationService.showNotification(
          id: 0,
          title: title,
          body: body,
        );
      } else {
        print("Notification reçue sans titre valide !");
      }
    });

    // Écoute des notifications cliquées
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification cliquée : ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hadja Store",
       home: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<String?>(
            future: provider.token(),
            builder: (context, snapshot) {
              final token = snapshot.data;
              return (token != null && token.isNotEmpty)
                  ? const MySplashScreen()
                  : const LoginPage();
            },
          );
        },
      ),
    );
  }
}
