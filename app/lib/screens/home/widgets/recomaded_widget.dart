import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';


class MyRecomadationWidget extends StatefulWidget {
  const MyRecomadationWidget({super.key});

  @override
  State<MyRecomadationWidget> createState() => _MyRecomadationWidgetState();
}

class _MyRecomadationWidgetState extends State<MyRecomadationWidget> {
final List<ArticlesModel> _data = ArticlesModel.data();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommandations",
                  style: GoogleFonts.roboto(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 22)
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> SingleProductVerSionSliver(item:_data[index])));
                      },
                      child:Container(
                        margin: const EdgeInsets.all(5),
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:const Color(0xFFf0fcf3),
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
