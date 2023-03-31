import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/about_us.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/verify_first_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileSettingPage extends StatefulWidget {
  const UserProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<UserProfileSettingPage> createState() => _UserProfileSettingPageState();
}

class _UserProfileSettingPageState extends State<UserProfileSettingPage> {
  final storage = const FlutterSecureStorage();
  String? _imageUrl = '';
  String? _firstName = '';
  String? _lastName = '';
  String? profileCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 25,
          right: 15,
          left: 15,
        ),
        children: [
          _buildHead(),
          const SizedBox(height: 15),
          _buildUserDetail(),
          const SizedBox(height: 40),
          _buildRowAboutAccount(),
          const SizedBox(height: 40),
          _buildRowNotifications(),
          const SizedBox(height: 40),
          _buildRowHelp(),
          const SizedBox(height: 50),
          Center(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => logout(),
              child: Container(
                width: 116,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB325F8),
                  ),
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _buildRowHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ช่วยเหลือ',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildRow('ศูนย์ช่วยเหลือ'),
        const SizedBox(height: 10),
        InkWell(
          child: _buildRow('เกี่ยวกับ'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AboutUsPage(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildRow('นโยบาย'),
      ],
    );
  }

  Widget _buildRowNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'การแจ้งเตือน',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildRow('ตั้งค่าการแจ้งเตือน'),
        const SizedBox(height: 10),
        _buildRow('ตั้งค่าความเป็นส่วนตัว'),
      ],
    );
  }

  Widget _buildRowAboutAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เกี่ยวกับบัญชี',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileEditPage(),
            ),
          ),
          child: _buildRow('แก้ไขข้อมูลส่วนตัว'),
        ),
        const SizedBox(height: 10),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => const VerifyFirstStepPage(),
            ),
          ),
          child: _buildRow('ยืนยันตัวตน'),
        ),
      ],
    );
  }

  Widget _buildRow(String title) {
    return Container(
      // color: Colors.red,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Image.asset(
            'assets/images/go.png',
            height: 11,
          ),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset('assets/images/back.png',
                    height: 40, width: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetail() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserProfileEditPage(),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: _imageUrl != null && _imageUrl != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: _imageUrl!,
                      fit: BoxFit.fill,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/profile_empty.png",
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _firstName ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(' '),
                        Text(
                          _lastName ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text(
                  'แก้ไขข้อมูล',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var data = await ManageStorage.read('profileData') ?? '';
      var result = json.decode(data);
      setState(() {
        _imageUrl = result['imageUrl'];
        _firstName = result['firstName'];
        _lastName = result['lastName'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void logout() async {
    await ManageStorage.deleteStorageAll();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFirstPage(),
      ),
    );
  }
}
