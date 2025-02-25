import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_color.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/screens/search/views/search_page.dart';

class MySearchSectionWidget extends StatefulWidget {
  final constraints;
  const MySearchSectionWidget({super.key, required this.constraints});

  @override
  State<MySearchSectionWidget> createState() => _MySearchSectionState();
}

class _MySearchSectionState extends State<MySearchSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10), horizontal: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
        height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
        child: TextFormField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Rechercher...",
              hintStyle: GoogleFonts.roboto(
                  fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                  fontWeight: FontWeight.normal,
                  color: AppColor.textColor),
              prefixIcon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: Icon(Icons.search_rounded, size:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)))),
        ),
      ),
    );
  }
}
