import 'package:flutter/material.dart';
import 'dart:async';
import 'player_model.dart';
import 'package:intl/intl.dart';

class PlayerDetailPage extends StatefulWidget {
  final Player player;
  const PlayerDetailPage(this.player, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final double playerAvatarSize = 150.0;
  double _sliderValue = 10.0;
  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  min: 0.0,
                  max: 10.0,
                  value: _sliderValue,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                ),
              ),
              Container(
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    '${_sliderValue.toInt()}',
                    style: const TextStyle(fontSize: 25.0),
                  )),
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  void updateRating() {
    if (_sliderValue < 5.0) {
      _ratingErrorDialog();
    } else {
      setState(() {
        widget.player.rating = _sliderValue.toInt();
      });
   }
  }

  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¿Estás seguro?'),
            content: const Text('No puedes suspender a una jugadora de este nivel...'),
            actions: <Widget>[
              TextButton(
                child: const Text('Entendido'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget get submitRatingButton {
    return ElevatedButton(
      onPressed: () => updateRating(),
      child: const Text('Guardar'),
    );
  }

  Widget get playerImage {
    return Hero(
      tag: widget.player.name,
      child: Container(
        height: playerAvatarSize,
        width: playerAvatarSize,
        constraints: const BoxConstraints(),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(offset: Offset(1.0, 2.0), blurRadius: 2.0, spreadRadius: -1.0, color: Color(0x33000000)),
              BoxShadow(offset: Offset(2.0, 1.0), blurRadius: 3.0, spreadRadius: 0.0, color: Color(0x24000000)),
              BoxShadow(offset: Offset(3.0, 1.0), blurRadius: 4.0, spreadRadius: 2.0, color: Color(0x1f000000))
            ],
            image: DecorationImage(fit: BoxFit.cover, alignment: Alignment.topCenter, image: NetworkImage(widget.player.imageUrl ?? ''))),
      ),
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.star,
          size: 40.0,
          color: Colors.amberAccent,
        ),
        Text('${widget.player.rating}/10', style: const TextStyle(fontSize: 30.0))
      ],
    );
  }

  Widget get playerProfile {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          playerImage,
          Text(widget.player.name, style: const TextStyle(fontSize: 32.0,), textAlign: TextAlign.center,),
          Text(widget.player.position.toString(), style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0)),
          Text('${widget.player.totalCaps} caps desde ${DateFormat('dd/MM/yyyy').format(widget.player.debut as DateTime)}', style: const TextStyle(fontSize: 20.0)),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: rating,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.player.rating.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('Conoce a ${widget.player.name}'),
      ),
      body: ListView(
        children: <Widget>[playerProfile, addYourRating],
      ),
    );
  }
}
