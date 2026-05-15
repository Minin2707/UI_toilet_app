import 'package:flutter/material.dart';

class AnimatedToiletMarker
    extends StatefulWidget {

  final bool approved;

  const AnimatedToiletMarker({
    super.key,
    required this.approved,
  });

  @override
  State<AnimatedToiletMarker> createState() =>
      _AnimatedToiletMarkerState();
}

class _AnimatedToiletMarkerState
    extends State<AnimatedToiletMarker>

    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.approved) {

      return Container(

        decoration: BoxDecoration(

          shape: BoxShape.circle,

          boxShadow: [

            BoxShadow(

              color:
                  Colors.greenAccent.withOpacity(0.55),

              blurRadius: 22,

              spreadRadius: 4,
            ),
          ],
        ),

        child: const Icon(

          Icons.wc,

          size: 38,

          color: Colors.greenAccent,
        ),
      );
    }

    return AnimatedBuilder(

      animation: _controller,

      builder: (context, child) {

        final scale =
            1 + (_controller.value * 0.18);

        return Transform.scale(

          scale: scale,

          child: Container(

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              boxShadow: [

                BoxShadow(

                  color:
                      Colors.orangeAccent.withOpacity(
                        0.45,
                      ),

                  blurRadius:
                      16 + (_controller.value * 12),

                  spreadRadius:
                      2 + (_controller.value * 4),
                ),
              ],
            ),

            child: const Icon(

              Icons.wc,

              size: 38,

              color: Colors.orangeAccent,
            ),
          ),
        );
      },
    );
  }
}