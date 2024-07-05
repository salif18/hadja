import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChooseCategoryWidget extends StatefulWidget {
  const MyChooseCategoryWidget({super.key});

  @override
  State<MyChooseCategoryWidget> createState() => _MyChooseCategoryState();
}

class _MyChooseCategoryState extends State<MyChooseCategoryWidget> {
  List<String> marques = ["Bracelet", "Creme", "Insecticide", "Pommade","The"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",
                      style: GoogleFonts.roboto(
                          fontSize: 24, fontWeight: FontWeight.w400)),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 22)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: marques.length,
                itemBuilder: (BuildContext context, int index) {
                  final String marque = marques[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 120,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:  const Color(0xFF1D1A30),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text( marque,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color:Colors.white),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
