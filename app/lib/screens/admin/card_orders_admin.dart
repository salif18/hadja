import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/admin/single_order_admin.dart';
import 'package:intl/intl.dart';

class CardOrderAdmin extends StatefulWidget {
  final OrdersModel order;
  final constraints;
  const CardOrderAdmin(
      {super.key, required this.order, required this.constraints});

  @override
  State<CardOrderAdmin> createState() => _CardOrderAdminState();
}

class _CardOrderAdminState extends State<CardOrderAdmin> {
  final ServicesApiOrders api = ServicesApiOrders();

  Future<void> _sendToServer(BuildContext context, newstatut) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      final response = await api.updateStatutOrders(newstatut, widget.order.id);
      final body = jsonDecode(response.body);
      Navigator.pop(context); // Close the dialog

      if (response.statusCode == 200) {
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      } else {
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Navigator.pop(context); // Close the dialog
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleOrder(
                    order: widget.order, constraints: widget.constraints)));
      },
      child: Padding(
        padding: EdgeInsets.all(widget.constraints.maxWidth *
            AppSizes.converValueToadapter(context, 8)),
        child: Container(
        
          width: widget.constraints.maxWidth,
          padding: EdgeInsets.all(widget.constraints.maxWidth *
              AppSizes.converValueToadapter(context, 15)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 20))),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("ORDER N° ${widget.order.id}",
                        style: GoogleFonts.roboto(
                            fontSize: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 12),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey[100],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date:",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12),
                        color: Colors.grey),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(widget.order.createdAt),
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12)),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Client:",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12),
                        color: Colors.grey),
                  ),
                  Text(
                    widget.order.telephone,
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12)),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Address:",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12),
                        color: Colors.grey),
                  ),
                  Text(
                    widget.order.address,
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12)),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order:",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12),
                        color: Colors.grey),
                  ),
                  Text(
                    widget.order.statusOfDelibery,
                    style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 12),
                      fontWeight: FontWeight.bold,
                      color: () {
                        switch (widget.order.statusOfDelibery) {
                          case "En attente":
                            return Colors.blue;
                          case "Livrer":
                            return Colors.green;
                          case "Annuler":
                            return Colors.red;
                          default:
                            return Colors.blue;
                        }
                      }(), // Exécution immédiate de la fonction anonyme
                    ),
                  )
                ],
              ),
              if (widget.order.statusOfDelibery == "En attente") ...[
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(
                                  widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 100),
                                  widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 30))),
                          onPressed: () {
                            _sendToServer(context, "Livrer");
                          },
                          child: Text("Valider la livraison",
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  color: Colors.white))),
                    ),
                    SizedBox(
                        width: widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 12)),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(
                                  widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 100),
                                  widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 30))),
                          onPressed: () {
                            _sendToServer(context, "Annuler");
                          },
                          child: Text("Annuler la livraison",
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 12),
                                  color: Colors.white))),
                    )
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
