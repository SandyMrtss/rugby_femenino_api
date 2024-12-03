import 'package:flutter/material.dart';
import 'player_model.dart';
import 'player_card.dart';

class PlayerList extends StatelessWidget {
  final List<Player> players;
  const PlayerList(this.players, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: players.length,
      // ignore: avoid_types_as_parameter_names
      itemBuilder: (context, int) {
        return PlayerCard(players[int]);
      },
    );
  }
}
