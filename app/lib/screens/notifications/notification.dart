import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/notification_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/notification_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/screens/notifications/single_notification.dart';
import 'package:intl/intl.dart';
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

  Future<List<NotificationModel>> _removeNotification(item) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await api.removeNotifications(userId, item.id);
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

  Future<List<NotificationModel>> _markReadNotification(item) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await api.readMarkNotifications(userId, item.id);
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 15)),
                  child: Text(
                    "Récents",
                    style: GoogleFonts.roboto(
                        fontSize: constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 14),
                        fontWeight: FontWeight.bold),
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
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = notifications[index];
                          return Dismissible(
                            key: Key(item.id!),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _removeNotification(item);
                            },
                            // confirmDismiss: (direction) async {
                            //   return await _showAlertDelete(context,constraints);
                            // },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 20)),
                              decoration: BoxDecoration(
                                color: Color(0xFF1D1A30),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 20)),
                                  bottomLeft: Radius.circular(
                                      constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 20)),
                                ),
                              ),
                              child: Icon(Icons.delete_rounded,
                                  size: constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 20),
                                  color: Colors.white),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _markReadNotification(item);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleOrderDeliveryNotification(
                                                orderId: item.orderId ?? "",
                                                constraints: constraints)));
                              },
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 8),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            color: Colors.grey,
                                            width: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 50),
                                            height: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 50),
                                            child: Image.asset(
                                              "assets/logos/logo3.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 8),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.username ?? "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: constraints
                                                            .maxWidth *
                                                        AppSizes
                                                            .converValueToadapter(
                                                                context, 16),
                                                  ),
                                                ),
                                                Text(
                                                  item.message,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: constraints
                                                            .maxWidth *
                                                        AppSizes
                                                            .converValueToadapter(
                                                                context, 12),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat("dd MMM yyyy")
                                                      .format(item.createdAt),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: constraints
                                                            .maxWidth *
                                                        AppSizes
                                                            .converValueToadapter(
                                                                context, 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    item.read == false
                                        ? Positioned(
                                            left: 5,
                                            top: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              width: constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 15),
                                              height: constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 15),
                                            ))
                                        : SizedBox.shrink(),
                                  ]),
                                  Container(
                                      height: 1,
                                      width: constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 250),
                                      color: Colors.grey[300]),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: notifications.length,
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
