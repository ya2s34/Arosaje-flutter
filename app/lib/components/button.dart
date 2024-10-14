import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      child: Container(
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Couleur de l'ombre
              spreadRadius: 1, // Rayon de dispersion de l'ombre
              blurRadius: 30, // Rayon de flou de l'ombre
              offset: Offset(0, 2), // Décalage de l'ombre
            ),
          ],
        ),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF3B9678)),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.arrowtriangle_right_circle_fill,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
