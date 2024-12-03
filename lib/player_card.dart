import 'player_model.dart';
import 'player_detail_page.dart';
import 'package:flutter/material.dart';


class PlayerCard extends StatefulWidget {
  final Player player;

  const PlayerCard(this.player, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _PlayerCardState createState() => _PlayerCardState(player);
}


class _PlayerCardState extends State<PlayerCard> {
  Player player;
  String? renderUrl;

  _PlayerCardState(this.player);

  @override
  void initState() {
    super.initState();
    renderPlayerPic();
  }

  Widget get playerImage {
    var playerAvatar = Hero(
      tag: widget.player.name,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration:
        BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, alignment: Alignment.topCenter, image: NetworkImage(renderUrl ?? ''))),
      ),
    );

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient:
          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black54, Colors.black, Color.fromARGB(255, 84, 110, 122)])),
      alignment: Alignment.center,
      child: const Text(
        'PLAYER',
        textAlign: TextAlign.center,
      ),
    );

    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: playerAvatar,
      // ignore: unnecessary_null_comparison
      crossFadeState: renderUrl == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  void renderPlayerPic() async {
    await player.getImageUrl();
    if (mounted) {
      setState(() {
        renderUrl = player.imageUrl;
      });
    }
  }

  Widget get playerCard {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 290,
        height: 115,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: const Color(0xFFF8F8F8),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.player.name,
                  style: const TextStyle(color: Color(0xFF000600), fontSize: 27.0),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Text(widget.player.position.toString(),
                      style: const TextStyle(color: Colors.black ,fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,

                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.star, color: Color(0xFF000600)),
                    Text(': ${widget.player.rating}/10',
                        style: const TextStyle(color: Color(0xFF000600), fontSize: 14.0),
                        textAlign: TextAlign.center,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPlayerDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) { return PlayerDetailPage(player);}))
        .then((value) => setState(() {})
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPlayerDetailPage(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              playerCard,
              Positioned(top: 7.5, child: playerImage),
            ],
          ),
        ),
      ),
    );
  }
}
