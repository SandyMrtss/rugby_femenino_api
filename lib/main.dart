import 'package:flutter/material.dart';
import 'dart:async';
import 'player_model.dart';
import 'player_list.dart';
import 'new_player_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rugby XV España',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyHomePage(
        title: 'Selección Femenina Rugby XV',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Player> initialPlayers = [Player('Alba Capell'), Player('Claudia Peña'), Player('Martina Márquez')];

  Future _showNewPlayerForm() async {
    var newPlayer = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddPlayerFormPage();
    }));
    if(newPlayer != null){
      if(!initialPlayers.contains(newPlayer)){
        initialPlayers.add(newPlayer);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Esta jugadora ya estaba añadida'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              showCloseIcon: true,
            )
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B479E),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewPlayerForm,
          ),
        ],
      ),
      body: Container(
          color: const Color.fromARGB(255, 88, 111, 137),
          child: Center(
            child: PlayerList(initialPlayers),
          )
      ),
    );
  }
}
