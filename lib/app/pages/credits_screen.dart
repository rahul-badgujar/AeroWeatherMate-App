import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/constants.dart' as constants;

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
              padding: constants.Paddings.paddingAll,
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

  // build Page Contents to show Credits
  Widget _buildPageContents() {
    return Padding(
      padding: constants.Paddings.pageContentsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDeveloperCreditsWidget(),
          _buildDataSourceCreditsWidget(),
          _buildResourcesUsedCreditsWidget(),
        ],
      ),
    );
  }

  // Custom App Bar
  Widget _buildCustomAppBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Text(
              "Credits",
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  // Developer Credit Widget
  Widget _buildDeveloperCreditsWidget() {
    return _buildCreditsWidget("About Developer",
        "Rahul Badgujar \nSE-IT Student \nPCCoE Pune, Maharashtra");
  }

  // Data Source Credit Widget
  Widget _buildDataSourceCreditsWidget() {
    return _buildCreditsWidget("Live Data", "Source : AirVisual",
        link: "www.iqair.com");
  }

  // Resources Used Credit Widget
  Widget _buildResourcesUsedCreditsWidget() {
    return _buildCreditsWidget(
        "Icon Authors", "Freepik, Pixel Perfect \nGoogle, bqlqn, Iconixer",
        link: "www.flaticon.com");
  }

  // template for Credit Widget
  Widget _buildCreditsWidget(String title, String content, {String link = ""}) {
    return Container(
      padding: constants.Paddings.paddingAll,
      margin: constants.Margins.rectMargin,
      child: Column(
        children: [
          Padding(
            padding: constants.Paddings.paddingAll,
            child: Text(
              title,
              style: _textStyleForTitle(),
            ),
          ),
          Text(
            content,
            style: _textStyleForBody(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: constants.Paddings.smallTextPadding,
            child: Text(
              link,
              style: _textStyleForLinks(),
            ),
          ),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  // text styles
  TextStyle _textStyleForTitle() {
    return Theme.of(context).textTheme.headline5;
  }

  TextStyle _textStyleForBody() {
    return Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
        );
  }

  TextStyle _textStyleForLinks() {
    Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.white60,
        );
  }
}
