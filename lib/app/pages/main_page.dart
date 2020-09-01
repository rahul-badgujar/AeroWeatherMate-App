import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/strings_rsc.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, @required this.appTitle}) : super(key: key);
  final String appTitle;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blueGrey,
          ),
          _buildInfoScene(widget.appTitle),
        ],
      ),
    );
  }

  Widget _buildInfoScene(String cityName) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            _buildTopBar(),
            _buildShortDetailWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: null,
          ),
          Expanded(
            child: Center(
              child: Text(
                Strings.defaultCityName,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ],
      ),
      decoration: BoxDecoration(),
    );
  }

  _buildShortDetailWidget() {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBigTempWidget(),
            _buildWeatherStatusWidget(),
            _buildAiqWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBigTempWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              Strings.defaultTemp,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "°" + Strings.defaultTempScale,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherStatusWidget() {
    return Container(
      child: Text(
        Strings.defaultWeatherStatus,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _buildAiqWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 180),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.eco,
              color: Colors.white,
            ),
          ),
          Text(
            "AIQ " + Strings.defaultAqi,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
