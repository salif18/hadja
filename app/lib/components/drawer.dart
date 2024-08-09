// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/api/profilImage_api.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:hadja_grish/screens/auth/login_page.dart';
import 'package:hadja_grish/screens/auth/update_password.dart';
import 'package:hadja_grish/screens/cart/widgets/maps.dart';
import 'package:hadja_grish/screens/admin/orders_admin.dart';
import 'package:hadja_grish/screens/client/orders_client.dart';
import 'package:hadja_grish/screens/livreur/orders_delibery.dart';
import 'package:hadja_grish/screens/admin/delivery_list.dart';
import 'package:hadja_grish/screens/admin/categorie_list.dart';
import 'package:hadja_grish/screens/admin/products_page.dart';
import 'package:hadja_grish/screens/livreur/list_delivery.dart';
import 'package:hadja_grish/screens/profil/update_profil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DrawerWindow extends StatefulWidget {
  const DrawerWindow({super.key});

  @override
  State<DrawerWindow> createState() => _DrawerWindowState();
}

class _DrawerWindowState extends State<DrawerWindow> {

  ServicesApiAuth api = ServicesApiAuth();
  ServicesApiProfil apiProfil = ServicesApiProfil();
  ImagePicker picker = ImagePicker();
  XFile? imageProfil ;
  XFile? newImageProfil ;
  

  late double lat;
  late double long;

  void getLatLng(position) {
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

//SELECTION DIMAGE POUR PROFIL
 Future<void> _loadImageFromGallery()async{
    XFile? imagePicked = await picker.pickImage(source:ImageSource.gallery);
    if(imagePicked != null){
   setState(() {
     imageProfil = imagePicked;
   });
   sendImageProfil();
  }
 }

// ENVOIE DE LIMAGE DANS LE SERVER
  Future<void> sendImageProfil()async{
        final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
     FormData  formData = FormData.fromMap({
      "user_id":userId,
      "photo":await MultipartFile.fromFile(imageProfil!.path, filename: imageProfil!.path.split("/").last)
     });
    try{
        final res = apiProfil.postPhotoProfil(formData);
        final data = res.data;
        if(res.statusCode == 201){
          print(data["photo"]);
        }
    }catch(e){
      print(e);
    }
  }


//SELECTION DE NOUVELLE IMAGE MODIFICATION
 Future<void> _loadNewImageFromGallery()async{
    XFile? newImagePicked = await picker.pickImage(source:ImageSource.gallery);
    if(newImagePicked != null){
   setState(() {
     newImageProfil = newImagePicked;
     print(newImagePicked);
   });
   sendUpdateImageProfil();
  }
 }


// MIS A JOURS DU PHOTO
Future<void> sendUpdateImageProfil() async {
  final provider = Provider.of<AuthProvider>(context, listen: false);
  final userId = await provider.userId();
  final imgPath = await MultipartFile.fromFile(newImageProfil!.path, filename: newImageProfil!.path.split("/").last);
  FormData formData = FormData.fromMap({
    "user_id": userId,
    "photo": imgPath
  });
  try {
    final res = await apiProfil.updatePhotoProfil(formData);
    if (res.statusCode == 200) {
      final data = res.data;
      print(data["message"]);
    } else {
      print('Erreur: ${res.statusCode} - ${res.statusMessage}');
    }
  } catch (e) {
     if (e is DioException) {
      // Gestion des erreurs Dio
      print('Erreur Dio: ${e.message}');
      print('Données de la requête: ${e.requestOptions.data}');
      print('Données de la réponse: ${e.response?.data}');
    } else {
      // Autres erreurs
      print('Exception: $e');
    }
  }
}
 
 // SUPPRIMER LA PHOTO
  Future<void> sendDeleteProfil()async{
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    var _data = {
          'user_id': userId,
        };
    try{
        final res = await apiProfil.deletePhotoProfil(_data);
        final data = res.data;
        if(res.statusCode == 200){
          print(data["message"]);
        }
    }catch(e){
      print(e);
    }
  }

// DECONNECTION API
  Future<void> logoutUserClearTokenTosServer(BuildContext context) async {
  final provider = Provider.of<AuthProvider>(context, listen: false);
  var token = await provider.token();
  provider.logoutButton();
  try {
    final res = await api.postLogoutTokenUser(token);
    if (res.statusCode == 200) {
      provider.logoutButton();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  } catch (error) {
    if (mounted) {
      api.showSnackBarErrorPersonalized(
        context,
        "Erreur lors de la déconnexion. $error",
      );
    }
  }
}

 //SUPPRIMER COMPTE API
   Future<void> _deleteUserClearTokenTosServer(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    var token = await provider.token();
    try {
      final res = await api.deleteUserTokenUserId(token);
      if (res.statusCode == 200) {
        provider.logoutButton();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } catch (error) {
      api.showSnackBarErrorPersonalized(
          context, "Erreur lors de la deconnexion. $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfosProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<ProfilModel?>(
          future: provider.loadProfilFromLocalStorage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              ProfilModel profil = snapshot.data!;
              return Drawer(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      child:Center(
                          child: Column(
                            children: [
                              profil.photo != null ?
                              GestureDetector(
                                onTap: (){
                                        _showUpdatePhoto();
                                },
                                child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage:  NetworkImage(
                                      profil.photo!,
                                    ) as ImageProvider,
                                     backgroundColor: Colors.transparent,
                                     
                                  ),
                              )
                              : GestureDetector(
                                onTap: (){
                                      _loadImageFromGallery();
                                    },
                                child: CircleAvatar(
                                  radius: 35,
                                   backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/images/add profil.png") as ImageProvider),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(profil.name ?? "user", style:GoogleFonts.aBeeZee(fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(profil.email ?? "user@gmail.com",style:GoogleFonts.aBeeZee(fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20, top: 15),
                              child: Text(
                                "Mon compte",
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UpdateProfil(),
                                  ),
                                );
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.person, size: 30, color: Colors.green),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Modifier profil",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UpdatePassword(),
                                  ),
                                );
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.lock, size: 30, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Changer password",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (profil.userStatut == "admin") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20, top: 15),
                                child: Text(
                                  "Administrateur",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyCategoriList(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    Icon(Icons.category, size: 30, color: Colors.purple[400]),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Categories",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProductPage(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    Icon(Icons.add, size: 30, color: Colors.grey[800]),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Produits",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DeliveryList(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.delivery_dining, size: 30, color: Color.fromARGB(255, 30, 125, 173)),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Livreurs",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminOders(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.filter_list_sharp, size: 30, color: Colors.amber),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Commandes",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (profil.userStatut == "delivery") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20, top: 15),
                                child: Text(
                                  "Livreurs",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OrdersLivreurs(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.filter_list_sharp, size: 30, color: Colors.lightBlue),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Commandes",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListOrderLivrer(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.check, size: 30, color: Colors.green),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Livrés",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (profil.userStatut == "client") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20, top: 15),
                                child: Text(
                                  "Clients",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MapsPage(
                                              getLatLng: getLatLng,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: Text(
                                                "Valider",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.location_searching_rounded, size: 30, color: Colors.green),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Addresse",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OrdersClient(),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: [
                                    const Icon(Icons.filter_list_outlined, size: 30, color: Colors.orange),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Commandes",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Widget à afficher si aucun des statuts ne correspond
                      Container(),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20, top: 15),
                              child: Text(
                                "Personel",
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                logoutUserClearTokenTosServer(context);
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.logout, size: 30),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Se déconnecter",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                _showConfirmDelete(context);
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.person_remove_sharp, size: 30, color: Colors.red),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Supprimer compte",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Aucune donnée disponible"));
            }
          },
        );
      },
    );
  }

_showConfirmDelete(BuildContext context) async{
 return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text("Avertissement")),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[100]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Non", style: TextStyle(color: Color(0xFF292D4E))),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF292D4E)),
                    onPressed: () {
                     _deleteUserClearTokenTosServer(context);
                    },
                    child: const Text("Oui", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

_showUpdatePhoto()async{
await showDialog(
  context: context,
   builder: (BuildContext context){
     return AlertDialog(
      content:Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
           TextButton.icon(onPressed: (){
                _loadNewImageFromGallery();
           }, 
           label: Text("Changer photo",style: GoogleFonts.roboto(fontSize: 18)),
           icon: Icon(Icons.camera_alt_rounded),
           ),
           Divider(height: 2,color:Colors.grey[200]),
           TextButton.icon(onPressed: (){
              sendDeleteProfil();
           }, 
           label: Text("Supprimer photo",style: GoogleFonts.roboto(fontSize: 18)),
           icon: Icon(Icons.remove_circle_outline_sharp),)
        ]) ,
     );
   }
   );
}

}

