import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  static const String apiBase = '673e0bb20118dbfe8609eb1e.mockapi.io';
  static final List<String> _allPlayers = [];

  void addPlayer(BuildContext context) {
    var newPlayer = Player(_formKey.currentState?.value["playerName"]);
    Navigator.of(context).pop(newPlayer);
  }


  void getPlayerList() async {
    if(_allPlayers.isNotEmpty) return;

    HttpClient http = HttpClient();

    try {
      var uri = Uri.https(apiBase,'/api/v1/players');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      List data = json.decode(responseBody);
      for(int i = 0; i < data.length; i++){
        _allPlayers.add(data[i]["name"]);
      }
      // allPlayers.sort()
    } catch (exception) {
      print(exception);
    }
  }

  int containsCaseInsensitive(List list, String string){
    for(int i = 0; i < list.length; i++){
      if(list[i].trim().toLowerCase() == string.trim().toLowerCase()){
         return i;
      }
    }
    return - 1;
  }

  void checkText(){
    if(nameController.text == "") return;
    if(_formKey.currentState?.value["playerName"] != null) return;
    int index = containsCaseInsensitive(_allPlayers, nameController.text);
    if(index != -1 ){
      _formKey.currentState?.fields["playerName"]?.didChange(_allPlayers[index]);
    }
    else{
      _formKey.currentState?.fields["playerName"]?.didChange(nameController.text);
    }
  }

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
              child:
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {_formKey.currentState!.save();},
                    child: FormBuilderTypeAhead<String>(
                      name: 'playerName',
                      initialValue: null,
                      controller: nameController,
                      hideOnEmpty: true,
                      hideOnUnfocus: true,
                      decoration: InputDecoration(
                        label: const Text(
                          "Nombre jugadora",
                          style: TextStyle(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white,),
                          onPressed: () {
                            _formKey.currentState!.fields['playerName']?.didChange(null);
                          }
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return _allPlayers.where((country) => country.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: "Elige una jugadora"),
                        FormBuilderValidators.containsElement(_allPlayers, errorText: "Jugadora desconocida")
                      ]),
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      checkText();
                      if(_formKey.currentState!.saveAndValidate()){
                        addPlayer(context);
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text('Añadir jugadora'),
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
