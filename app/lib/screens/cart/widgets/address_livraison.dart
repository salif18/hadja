import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadja_grish/screens/cart/widgets/maps.dart';



class AddressLivraison extends StatefulWidget {
  const AddressLivraison({super.key});

  @override
  State<AddressLivraison> createState() => _AddressLivraisonState();
}

class _AddressLivraisonState extends State<AddressLivraison> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController address = TextEditingController();
  late double lat;
  late double long;

  Map<String,dynamic> order = {
      "orderId":"",
      "userId":"", 
      "address":"", 
      "latitude":"",
      "longitude":"", 
      "tel":"", 
      "total":"", 
      "statutOfDelivery":"", 
      "articles":""
    };

  @override
  void dispose() {
    address.dispose();
    super.dispose();
  }

  void getLatLng(LatLng position) {
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xfff0fcf3),
          ),
          child: _formulaires(context),
        ),
      ),
    );
  }

  Widget _formulaires(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Faites-vous livrer chez vous !",
                  style: GoogleFonts.abel(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Remplissez bien les renseignements",
                  style: GoogleFonts.abel(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: const DecorationImage(
                image: AssetImage("assets/logos/delibery.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: address,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Ville/quartier",
                hintStyle: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.home, size: 33),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MapsPage(getLatLng: getLatLng),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text("Valider", style: GoogleFonts.roboto(fontSize: 20, color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Coordonnées géographiques", style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_searching, size: 28, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {},
              child: Text("Passer commande", style: GoogleFonts.roboto(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
