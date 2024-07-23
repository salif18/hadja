import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/search/views/search_page.dart';

class MySearchSectionWidget extends StatefulWidget {
  const MySearchSectionWidget({super.key});

  @override
  State<MySearchSectionWidget> createState() => _MySearchSectionState();
}

class _MySearchSectionState extends State<MySearchSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 100,
        child: TextFormField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Rechercher...",
              hintStyle: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              prefixIcon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: const Icon(Icons.search_rounded, size: 35),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20))),
        ),
      ),
    );
  }
}
