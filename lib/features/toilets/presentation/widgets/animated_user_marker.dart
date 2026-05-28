import 'package:flutter/material.dart';

class AnimatedUserMarker
    extends StatefulWidget {

  const AnimatedUserMarker({
    super.key,
  });

  @override
  State<AnimatedUserMarker> createState() =>
      _AnimatedUserMarkerState();
}

class _AnimatedUserMarkerState
    extends State<AnimatedUserMarker>

    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat();
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: _controller,

      builder: (context, child) {

        final pulse =
            _controller.value;

        return Stack(

          alignment: Alignment.center,

          children: [

            Container(

              width: 40 + (pulse * 12),
              height: 40 + (pulse * 12),

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.cyanAccent.withOpacity(
                      0.18 * (1 - pulse),
                    ),
              ),
            ),

            Container(

              width: 22,
              height: 22,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color: Colors.cyanAccent,

                boxShadow: [

                  BoxShadow(

                    color:
                        Colors.cyanAccent.withOpacity(0.8),

                    blurRadius: 8,

                    spreadRadius: 1,
                  ),
                ],
              ),
            ),

            Container(

              width: 10,
              height: 10,

              decoration: const BoxDecoration(

                shape: BoxShape.circle,

                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}