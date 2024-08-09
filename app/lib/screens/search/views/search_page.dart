import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/screens/search/widgets/card_recherche.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ServicesAPiProducts api = ServicesAPiProducts();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ArticlesModel> articles = [];
  TextEditingController searchValue = TextEditingController();
  List<ArticlesModel> resultOfSearch = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
    _loadRecentSearches();

    // Ajouter un écouteur pour le champ de recherche
    searchValue.addListener(() {
      setState(() {
        if (searchValue.text.isEmpty) {
          resultOfSearch = [];
        } else {
          resultOfSearch = articles
              .where((item) => item.name
                  .toLowerCase()
                  .contains(searchValue.text.toLowerCase()))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    searchValue.dispose();
    super.dispose();
  }

  void _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  void _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', recentSearches);
  }

  void addRecentSearch(String search) {
    if (!recentSearches.contains(search)) {
      setState(() {
        recentSearches.add(search);
        if (recentSearches.length > 5) {
          recentSearches.removeAt(0); // Garder seulement les 5 recherches les plus récentes
        }
        _saveRecentSearches();
      });
    }
  }

  void _handleSearch(String value) {
    if (value.isNotEmpty) {
      addRecentSearch(value);
    }
    setState(() {
      resultOfSearch = articles
          .where((item) => item.name
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

void _removeRecenteSearch(String search){
   setState(() {
     recentSearches.remove(search);
     _saveRecentSearches();
   });
}

Future<void> _getProducts() async {
    try {
      final res = await api.getAllProducts();
      final body = jsonDecode(res.body);
      if(res.statusCode == 200){
        setState(() {
            articles =
        (body["articles"] as List).map((json)=> ArticlesModel.fromJson(json)).toList();
        });
    
      }
    } catch (e) {
      // articles.addError("");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 95,
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: searchValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              prefixIcon: const Icon(Icons.search, size: 28),
              hintText: "Rechercher",
              hintStyle: GoogleFonts.roboto(fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            onFieldSubmitted: _handleSearch,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: searchValue.text.isEmpty
              ? recentSearches.reversed.map((search) {
                  return ListTile(
                    trailing: IconButton(onPressed: (){
                      _removeRecenteSearch(search);
                    }, icon: Icon(Icons.highlight_remove_rounded, size:24, color:Colors.grey[400])),
                    title: Row(
                      children: [const Icon(Icons.history,size:24),
                      const SizedBox(width: 10),
                        Text(search,style:GoogleFonts.roboto(fontSize:22,fontWeight: FontWeight.normal)),
                      ],
                    ),
                    onTap: () {
                      searchValue.text = search;
                      searchValue.selection = TextSelection.fromPosition(
                        TextPosition(offset: searchValue.text.length),
                      );
                      _handleSearch(search);
                    },
                  );
                }).toList()
              : resultOfSearch.isEmpty
                  ? [Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('Aucun résultat trouvé',style:GoogleFonts.roboto(fontSize:20,)),
                  )]
                  : resultOfSearch.map((item) {
                      return ResultSearch(item: item);
                    }).toList(),
        ),
      ),
    );
  }
}
