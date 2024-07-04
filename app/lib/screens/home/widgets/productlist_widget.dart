import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/screens/articles/articles.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';


class MyProductListWidget extends StatefulWidget {
  const MyProductListWidget({super.key});

  @override
  State<MyProductListWidget> createState() => _MyProductListWidgetState();
}

class _MyProductListWidgetState extends State<MyProductListWidget> {
    final List<ArticlesModel> _data = ArticlesModel.data();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nos produits",
                  style: GoogleFonts.roboto(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context)=> const MyArticlePage()));
                  },
                  child: Text(
                    "Explorer tous",
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color:  const Color(0xFF55AB60)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
              child: GridView.builder(
                  itemCount: _data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> SingleProductVerSionSliver(item:_data[index])));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xfff0fcf3),
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Image.asset(
                            _data[index].img,
                            fit: BoxFit.contain,
                                                     ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_data[index].name,style:GoogleFonts.roboto(fontSize:20,fontWeight:FontWeight.w600)),  
                              Text("${_data[index].price.toString()} fcfa",style:GoogleFonts.roboto(fontSize:18,color:Colors.grey[500]))
                            ],
                          ),
                        ),
                      
                      ],),
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  
}
