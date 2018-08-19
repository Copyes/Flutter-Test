import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'dart:async';

class TimerPage extends StatefulWidget {
  @override
  createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  String _sectionTime = '00:00.00';
  String _totalTime = '00:00.00';
  int _recordTime = 0;

  Stopwatch _stopwatch = Stopwatch();
  List<String> _recordList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Sport Watch'),
        ),
        body: Column(
          children: <Widget>[
            WatchFace(sectionTime: _sectionTime, totalTime: _totalTime),
            WatchControl(
              watchOn: _stopwatch.isRunning,
              onLeftBtn: _handleLeftBtn,
              onRightBtn: _handleRightBtn,
            ),
            Expanded(
              child: WatchRecord(recordList: _recordList),
            )
          ],
        ));
  }

  void _handleRightBtn() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
      Timer.periodic(Duration(milliseconds: 10), (interval) {
        var milSecond,
            second,
            minute,
            countingTime,
            secmilSecond,
            secsecond,
            secminute,
            seccountingTime;
        countingTime = _stopwatch.elapsedMilliseconds;
        minute = (countingTime / (60 * 1000)).floor();
        second = ((countingTime - 6000 * minute) / 1000).floor();
        milSecond = ((countingTime % 1000) / 10).floor();
        seccountingTime = countingTime - _recordTime;
        secminute = (seccountingTime / (60 * 1000)).floor();
        secsecond = ((seccountingTime - 6000 * secminute) / 1000).floor();
        secmilSecond = ((seccountingTime % 1000) / 10).floor();

        setState(() {
          _totalTime = (minute % 60).toString().padLeft(2, '0') +
              ":" +
              (second % 60).toString().padLeft(2, '0') +
              "." +
              (milSecond % 60).toString().padLeft(2, '0');
          _sectionTime = (secminute % 60).toString().padLeft(2, '0') +
              ":" +
              (secsecond % 60).toString().padLeft(2, '0') +
              "." +
              (secmilSecond % 60).toString().padLeft(2, '0');
        });
        if (!_stopwatch.isRunning) {
          interval.cancel();
        }
      });
    }
  }

  void _handleLeftBtn() {
    if (_stopwatch.isRunning) {
      _recordList.add(_sectionTime);
      _recordTime = _stopwatch.elapsedMilliseconds;
    } else {
      setState(() {
        _sectionTime = '00:00.00';
        _totalTime = '00:00.00';
        _recordList.clear();
        _recordTime = 0;
      });

      _stopwatch.reset();
    }
  }
}

// the main part
class WatchFace extends StatelessWidget {
  WatchFace({
    Key key,
    this.sectionTime: '00:00.00',
    this.totalTime: '00:00.00',
  }) : super(key: key);

  final String sectionTime;
  final String totalTime;
  Widget timeBox(BuildContext context, String totalTime, String typeStr) {
    var totalTimeArr = totalTime.split(new RegExp(r"\D"));
    var fontSize = (typeStr == 'big') ? 70.0 : 20.0;
    var width = (typeStr == 'big') ? 92.0 : 28.0;
    var color = (typeStr == 'big') ? Color(0xFF222222) : Color(0xFF555555);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          child: Text(
            totalTimeArr[0],
            style: new TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w100,
                color: color,
                fontFamily: "RobotoMono"),
          ),
        ),
        Container(
          child: Text(
            ':',
            style: new TextStyle(
                fontSize: fontSize, color: color, fontFamily: "RobotoMono"),
          ),
        ),
        Container(
          width: width,
          child: Text(
            totalTimeArr[1],
            style: new TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w100,
                color: color,
                fontFamily: "RobotoMono"),
          ),
        ),
        Container(
          child: Text(
            '.',
            style: new TextStyle(
                fontSize: fontSize, color: color, fontFamily: "RobotoMono"),
          ),
        ),
        Container(
          width: width,
          child: Text(
            totalTimeArr[2],
            style: new TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w100,
                color: color,
                fontFamily: "RobotoMono"),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD)))),
      padding: EdgeInsets.only(top: 30.0),
      alignment: Alignment.center,
      height: 150.0,
      child: Column(
        children: <Widget>[
          timeBox(context, sectionTime, 'small'),
          timeBox(context, totalTime, 'big'),
        ],
      ),
    );
  }
}

// the control part
class WatchControl extends StatefulWidget {
  WatchControl(
      {Key key,
      @required this.onRightBtn,
      @required this.onLeftBtn,
      this.watchOn})
      : super(key: key);
  final Function onRightBtn;
  final Function onLeftBtn;
  final bool watchOn;
  @override
  createState() => WatchControlState();
}

class WatchControlState extends State<WatchControl> {
  String startBtnText = '启动';
  Color startBtnColor = Color(0xFF60B644);
  String stopBtnText = '复位';
  Color underlayColor = Color(0xFFEEEEEE);

  _onRightBtn() {
    if (!widget.watchOn) {
      setState(() {
        startBtnText = '停止';
        startBtnColor = Color(0xFFFF0044);
        stopBtnText = '计次';
        underlayColor = Color(0xFFEEEEEE);
      });
    } else {
      setState(() {
        startBtnText = '启动';
        startBtnColor = Color(0xFF60B644);
        stopBtnText = '复位';
        underlayColor = Color(0xFFEEEEEE);
      });
    }

    widget.onRightBtn();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 100.0,
      decoration: BoxDecoration(color: Color(0xFFF3F3F3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Ink(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(35.0))),
            child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                onTap: widget.onLeftBtn,
                child: Center(
                  child: Text(stopBtnText),
                )),
          ),
          Ink(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(35.0))),
            child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                onTap: _onRightBtn,
                child: Center(
                  child: Text(
                    startBtnText,
                    style: TextStyle(color: startBtnColor),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

// the record list part
class WatchRecord extends StatelessWidget {
  WatchRecord({Key key, this.recordList}) : super(key: key);
  final List<String> recordList;
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recordList.length,
      itemBuilder: (context, index) {
        int targetIndex = recordList.length - index;

        return Container(
          height: 40.0,
          padding:
              EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0, bottom: 5.0),
          decoration: BoxDecoration(
              border: BorderDirectional(
                  bottom: BorderSide(color: Color(0xFFBBBBBB)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Text(
                  '计次 $targetIndex',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ),
              Expanded(
                child: Text(
                  recordList[targetIndex - 1],
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Color(0xFF222222), fontFamily: "RobotoMono"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
