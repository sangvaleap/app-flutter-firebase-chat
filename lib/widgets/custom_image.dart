import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
    this.name, {
    this.width = 100,
    this.height = 100,
    this.bgColor,
    this.borderWidth = 0,
    this.borderColor,
    this.trBackground = false,
    this.isSVG = true,
    this.radius = 50,
  });

  final String name;
  final double width;
  final double height;
  final double borderWidth;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isSVG;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return isSVG ? _buildSVG(context) : _buildNetworkImage(context);
  }

  Widget _buildNetworkImage(context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Theme.of(context).cardColor,
          width: borderWidth,
        ),
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 2), // changes position of shadow
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(name),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSVG(context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Theme.of(context).cardColor,
          width: borderWidth,
        ),
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.string(
        multiavatar(name, trBackground: trBackground),
      ),
    );
  }
}
