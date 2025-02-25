import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/notification_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/notification_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationServices api = NotificationServices();

  Future<List<NotificationModel>> _getNotification() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await api.getNotifications(userId);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return (body["notifications"] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e); // Affiche l'erreur pour le debug
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                toolbarHeight: constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 50),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Notifications",
                    style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 16),
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<NotificationModel>>(
                future: _getNotification(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "Problème de connexion",
                          style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 12),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "Aucune notification",
                          style: GoogleFonts.roboto(
                            fontSize: constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 12),
                          ),
                        ),
                      ),
                    );
                  } else {
                    final notifications = snapshot.data!;
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 15),
                        vertical: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 5),
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = notifications[index];
                            return GestureDetector(
                              onTap: (){},
                              child: Container(
                                padding:  EdgeInsets.all(constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 8),),
                                margin: EdgeInsets.symmetric(vertical:constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 4),),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 8),),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item.message,
                                  style: GoogleFonts.roboto(fontSize: constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 12),),
                                ),
                              ),
                            );
                          },
                          childCount: notifications.length,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
