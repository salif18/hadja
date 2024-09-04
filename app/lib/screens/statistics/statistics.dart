import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/screens/statistics/widgets/barchart.dart';


class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text("Statistics",style: GoogleFonts.roboto(fontSize:AppSizes.fontLarge),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined, size: AppSizes.iconLarge,)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [ 
            Column(
              children: [ 
                Padding(padding: const EdgeInsets.all(8), child: Text(""),),
                BarChartWidget()
              ],
            )
          ],
        ),
      ),
    );
  }
}