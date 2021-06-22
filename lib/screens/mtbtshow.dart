import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musopathy/models/mtbt.dart';
import 'package:musopathy/widgets/custom_drawer.dart';

class Mtbtshow extends StatelessWidget {
  final List<Mtbt> data = [
    Mtbt(
        "Musopathy is the study of the fundamental mechanics of musical impact on different parts of the brain or body of humans, animals, plants and micro entities in a quantifiably precise manner.  Musopathy re-engineers the arena of Music Therapy with its de-regionalised and de-culturalised creations of Clinical Music for more precise studies and is therefore an exciting area with huge therapeutic as well as commercial potential.",
        Colors.white),
    Mtbt(
        "Applied Musopathy offers specially evolved evidence-based Health and Wellness solutions for conditions such as Covid 19, COPD, Stress, Anxiety, Depression, Pain Management etc besides Leadership Training and Team building programs for Corporates such as Tonation Breathing Techniques (TBT).",
        Colors.white),
    // Mtbt(, c),
    // Mtbt(text, c),
    // Mtbt(),
    // Mtbt(, c)
  ];
  final GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      key: key1,
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Theme.of(context).primaryColor,
            onPressed: () => key1.currentState.openDrawer()),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'M U S O P A T H Y',
          style: TextStyle(
            color: Color.fromRGBO(40, 115, 161, 1.0),
            fontFamily: 'Ubuntu',
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child:
                      Text(data[index].text, style: TextStyle(fontSize: 17))),
              color: data[index].c,
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }
}
