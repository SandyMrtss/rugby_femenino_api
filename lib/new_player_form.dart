import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'player_model.dart';

class AddPlayerFormPage extends StatefulWidget {
  const AddPlayerFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddPlayerFormPageState createState() => _AddPlayerFormPageState();
}

class _AddPlayerFormPageState extends State<AddPlayerFormPage> {
  TextEditingController nameController = TextEditingController();
  static const String apiBase = '673e0bb20118dbfe8609eb1e.mockapi.io';
  static List allPlayers = [];

  void submitPup(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Introduce el nombre de la jugadora que quieres añadir'),
      ));
    }
    else if(!allPlayers.contains(nameController.text)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Jugadora no conocida. Asegúrate de escribir el nombre correctamente'),
      ));
    }
    else {
      var newPlayer = Player(nameController.text);
      Navigator.of(context).pop(newPlayer);
    }
  }

  /*Widget getAutocomplete(){
    return FormBuilderTypeAhead<String>(
      name: 'country',
      initialValue: null,
      decoration: const InputDecoration(
        labelText: 'Which country are you visiting?',
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      suggestionsCallback: (pattern) {
        return allPlayers.where((country) => country.toLowerCase().startsWith(pattern.toLowerCase())).toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.required(),
    ),
  }*/

  Future<void> getPlayerList() async {
    HttpClient http = HttpClient();

    try {
      var uri = Uri.https(apiBase,'/api/v1/players');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      List data = json.decode(responseBody);
      for(int i = 0; i < data.length; i++){
        allPlayers.add(data[i]["name"]);
      }

    } catch (exception) {
      print(exception);
    }
  }

/*  void showPlayerList(){
    print(allPlayers);
  }
*/
  @override
  Widget build(BuildContext context) {
    getPlayerList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new player'),
        backgroundColor: const Color(0xFF0B479E),
      ),
      body: Container(
        color: const Color(0xFFABCAED),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: nameController,
                style: const TextStyle(decoration: TextDecoration.none),
                onChanged: (v) => nameController.text = v,
                decoration: const InputDecoration(
                  labelText: 'Nombre jugadora',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          /*  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => showPlayerList(),
                    child: const Text('Help'),
                  );
                },
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => submitPup(context),
                    child: const Text('Submit Player'),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
