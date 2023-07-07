import 'package:flutter/material.dart';

class DataError extends StatefulWidget {
  const DataError({
    Key? key,
    this.height: 100,
    required this.onTap,
    this.color: Colors.black,
  }) : super(key: key);

  final double height;
  final Function() onTap;
  final Color color;

  @override
  _DataErrorState createState() => _DataErrorState();
}

class _DataErrorState extends State<DataError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, color: widget.color),
              SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                  style: TextStyle(color: widget.color),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          widget.onTap != null
              ? IconButton(
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 30,
                  ),
                  onPressed: widget.onTap,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
