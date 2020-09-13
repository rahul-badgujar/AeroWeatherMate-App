import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.gradientBox(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomAppBar(),
                  Expanded(
                    child: _buildPageContents(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContents() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _buildDeveloperCreditsWidget(),
          _buildDataSourceCreditsWidget(),
          _buildResourcesUsedCreditsWidget(),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Text(
              "Credits",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCreditsWidget() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "About Developer",
              style: _textStyleForTitle(),
            ),
          ),
          Text(
            "Rahul Badgujar \nSE-IT Student \nPCCoE Pune, Maharashtra",
            style: _textStyleForBody(),
            textAlign: TextAlign.center,
          )
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  Widget _buildDataSourceCreditsWidget() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Live Data",
              style: _textStyleForTitle(),
            ),
          ),
          Text(
            "Source : AirVisual",
            style: _textStyleForBody(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "www.iqair.com",
              style: _textStyleForLinks(),
            ),
          ),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  TextStyle _textStyleForLinks() =>
      TextStyle(color: Colors.white, fontSize: 15);

  Widget _buildResourcesUsedCreditsWidget() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Icon Authors",
              style: _textStyleForTitle(),
            ),
          ),
          Text(
            "Freepik, Pixel Perfect \nGoogle, bqlqn, Iconixer",
            style: _textStyleForBody(),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "www.flaticon.com",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  TextStyle _textStyleForTitle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 24,
    );
  }

  TextStyle _textStyleForBody() {
    return TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }
}
