import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: const Text(
          'Politique de confidentialité',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Dernière mise à jour : 23/03/2024\n\n'),
                TextSpan(
                    text:
                        'Cette Politique de Confidentialité décrit comment Arosa-je collecte, utilise et partage vos informations personnelles lorsque vous utilisez notre application mobile\n\n'),
                TextSpan(
                    text: '1. Collecte et Utilisation des Informations\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Nous collectons et utilisons certaines informations personnelles dans le cadre de l\'utilisation de notre Application. Ces informations peuvent inclure :\n- Les photos des plantes que vous souhaitez faire garder.\n- Les informations que vous fournissez volontairement, telles que votre nom d\'utilisateur et votre adresse e-mail.\n- Les données d\'utilisation de l\'Application, telles que les interactions avec l\'interface et les fonctionnalités.\n- Nous utilisons ces informations dans le but de fournir et d\'améliorer notre Application, y compris pour vous permettre de faire garder vos plantes et de recevoir des conseils d\'entretien appropriés.\n\n'),
                TextSpan(
                    text: '2. Consentement\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- En utilisant notre Application, vous consentez à la collecte et à l\'utilisation de vos informations personnelles conformément à cette Politique de Confidentialité. Vous avez le droit de retirer votre consentement à tout moment en nous contactant à arosaje@arosaje.com.\n\n'),
                TextSpan(
                    text: '3. Partage des Informations\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Nous ne partageons pas vos informations personnelles avec des tiers, sauf dans les cas suivants :\n- Lorsque cela est nécessaire pour fournir les services de l\'Application, tel que décrit dans la présente Politique de Confidentialité.\n- Lorsque nous sommes légalement tenus de le faire pour nous conformer à la loi applicable, aux procédures judiciaires, ou aux demandes des autorités gouvernementales.\n- Avec votre consentement préalable.\n\n'),
                TextSpan(
                    text: '4. Sécurité des Données\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Nous prenons des mesures raisonnables pour protéger vos informations personnelles contre la perte, l\'abus et l\'accès non autorisé. Cela comprend l\'utilisation de mesures de sécurité techniques et organisationnelles appropriées.\n\n'),
                TextSpan(
                    text: '5. Droits des Utilisateurs\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Vous avez certains droits concernant vos informations personnelles, y compris le droit d\'accéder à vos données, de les corriger, de les supprimer et de limiter leur utilisation. Pour exercer ces droits, veuillez nous contacter à arosaje@arosaje.com.\n\n'),
                TextSpan(
                    text: '6. Modifications de cette Politique\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Nous nous réservons le droit de modifier cette Politique de Confidentialité à tout moment. Toute modification entrera en vigueur dès sa publication sur l\'application. Nous vous encourageons à consulter régulièrement cette page pour rester informés des mises à jour.\n\n'),
                TextSpan(
                    text: '7. Contact\n\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        '- Si vous avez des questions ou des préoccupations concernant cette Politique de Confidentialité, veuillez nous contacter à arosaje@arosaje.com.\n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
