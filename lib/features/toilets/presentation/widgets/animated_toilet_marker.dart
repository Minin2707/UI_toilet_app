import 'package:flutter/material.dart';

class AnimatedToiletMarker
    extends StatelessWidget {

  final String status;

  const AnimatedToiletMarker({

    super.key,

    required this.status,
  });

  static const Color approvedColor =
      Colors.greenAccent;

  static const Color pendingColor =
      Colors.orangeAccent;

  static const Color revalidationColor =
      Colors.redAccent;

  @override
  Widget build(BuildContext context) {

    Color color;

    switch (status) {

      case 'APPROVED':

        color = approvedColor;

        break;

      case 'NEEDS_REVALIDATION':

        color = revalidationColor;

        break;

      default:

        color = pendingColor;
    }

    return Container(

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        boxShadow: [

          BoxShadow(

            color: color.withOpacity(0.22),

            blurRadius: 8,

            spreadRadius: 1,
          ),
        ],
      ),

      child: Icon(

        Icons.wc,

        size: 36,

        color: color,
      ),
    );
  }
}