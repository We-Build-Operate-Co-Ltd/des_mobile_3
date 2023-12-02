import 'dart:math';

import 'package:des/shared/config.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:intl/intl.dart';

const List<dynamic> mockDataList = [
  mockDataObject1,
  mockDataObject2,
];
const dynamic mockDataObject1 = {
  'title': 'สกัดสมุนไพร เพื่อผลิตภัณฑ์เสริมความงาม',
  'imageUrl': '$server/raot-document/images/aboutUs/aboutUs_232327200.png',
  'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
  'view': 5,
  'description':
      '''คอร์สนี้คุณจะได้เรียนวิธีการนำสมุนไพรไทยในรูปแบบต่างๆ มาสกัดเพื่อให้ได้สารสำคัญไปใช้ในผลิตภัณฑ์เสริมความงาม สมุนไพรที่นำมาสกัดมีหลากหลายรูปแบบ ครอบคลุมทั้งสมุนไพรไทยและสมุนไพรจีน ที่มีสรรพคุณช่วยบำรุงผิวพรรณ ฟื้นฟูสภาพผิว ต้านอนุมูลอิสระ ลบเลือนรอยดำต่างๆ เพื่อนำไปประยุกต์ใช้กับผลิตภัณฑ์แฮนด์เมดต่างๆ หรือใครที่ต้องการเรียนรู้การสกัดสมุนไพรเพื่อนำไปจัดจำหน่ายในรูปแบบของสารสกัด ให้กับคนที่ขาดแคลนวัตถุดิบ
ในคอร์สนี้คุณจะได้เรียนกับอาจารย์ภาควิชาเคมี โดยที่อาจารย์ได้ทำการทดลองในห้องปฏิบัติการแล้ว โดยมีงานวิจัยอ้างอิงและครูเรได้นำมาทำให้อยู่ในรูปแบบอย่างง่ายที่ทุกคนสามารถสกัดได้ โดยปรับใช้/ประยุกต์ใช้กับอุปกรณ์ในครัวเรือนที่ปรับใช้ให้ถูกหลักการทางวิทยาศาสตร์และที่สำคัญในห้องเรียนนี้ อาจารย์จะสอนให้คุณทำการทดสอบสารสำคัญว่าสารที่สกัดมานั้นมีสารสำคัญชนิดนั้นอยู่จริงหรือไม่
คอร์สเรียนนี้เหมาะอย่างยิ่งสำหรับคนที่อยากจะทำสารสกัดเพื่อส่งเสริมผลิตภัณฑ์ของตัวเอง และสำหรับคนที่อยากจะเรียนเพื่อนำความรู้ไปไว้ตอบลูกค้าว่าได้สารสกัดแต่ละชนิดมาได้โดยวิธีการใด และสามารถตรวจสอบสารสำคัญได้จริงหรือไม่ รวมไปถึงคนที่ยังทำงานแฮนด์เมดไม่เป็น แต่อยู่ในแหล่งวัตถุดิบ อยากจะแปรรูปสมุนไพรของตัวเองให้อยู่ในรูปสารสกัด โดยเฉพาะคนที่ทำนาข้าว สามารถแปรรูปข้าวให้ได้สารสกัดที่ดีต่อผิว เพิ่มความชุ่มชื้น มีสารต้านอนุมูลอิสระ คืนความอ่อนเยาว์ให้แก่ผิว
คอร์สเรียนนี้คุณจะได้เรียนรู้การสกัดสมุนไพรแทบทุกประเภทไม่ว่าจะเป็น แบบสดฉ่ำน้ำ แบบสดไม่ฉ่ำน้ำ พืชสมุนไพรที่เป็นหัว หรือพืชสมุนไพรที่มีน้ำมันหอมระเหย นอกจากนี้ยังมีสมุนไพรแบบสดและแบบแห้ง
คุณจะได้เรียนรู้การสกัดสมุนไพรที่เหมาะสมสำหรับผลิตภัณฑ์แต่ละชนิด พร้อมกับสอนให้ทุกคนรู้จักการต่อยอดจากสิ่งที่สอนอีกด้วย
ดังนั้นในห้องเรียนนี้ คุณจะได้พบกับการเรียนรู้วิธีสกัดสมุนไพร ที่ครอบคลุมตั้งแต่พื้นฐาน ไปถึงขั้นต่อยอดงานวิจัย ที่ตั้งใจสอนให้ทุกคนทำง่าย ทำเป็น เข้าถึงได้ง่าย
ประโยชน์ที่ผู้เรียนจะได้รับ
1) ลดรายจ่าย จากการซื้อสารสกัดสมุนไพร
2) เพิ่มรายได้จากการขายสารสกัดสมุนไพร
3) ได้สารสกัดสมุนไพรที่มีคุณภาพ มีมาตรฐาน ตรวจสอบคุณภาพได้ และทำได้ด้วยตัวเอง
4) ได้เรียนรู้การค้นหาจุดขายของผลิตภัณฑ์แฮนด์เมด
5) เรียนรู้การใช้งานวิจัย เพื่ออ้างอิงผลิตภัณฑ์แฮนด์เมดที่เราผลิต
6) เรียนรู้การตลาดในการขายผลิตภัณฑ์เครื่องสำอางเสริมความงาม
7) สามารถตอบคำถามเชิงลึกเกี่ยวกับผลิตภัณฑ์ที่เราผลิตหรือขาย ให้กับลูกค้าของเราได้
8) สามารถประยุกต์การสกัดสมุนไพร ได้กับสมุนไพรทุกชนิด ทุกประเภท
9) สามารถนำผัก ผลไม้ สมุนไพรใกล้ตัวมาสร้างมูลค่าเพิ่ม
10) สามารถนำความรู้ไปถ่ายทอดให้กับผู้อื่น เป็นวิทยากรในชุมชน หรือสร้างคอร์สออนไลน์สอนผู้ที่สนใจต่อไป
ใครควรเรียนคอร์สออนไลน์นี้
1) คนที่ทำงานในวงการเเฮนด์เมด คนทำผลิตภัณฑ์เครื่องสำอาง ผู้ผลิต ผู้ประกอบการ ที่ใช้สารสกัดสมุนไพรในผลิตภัณฑ์ เพื่อลดค่าใช้จ่ายในการซื้อสารสกัด และมั่นใจในคุณภาพ
2) คนที่มีวัตถุดิบ อยู่ในแหล่งวัตถุดิบ มีสมุนไพร หรือหาสมุนไพรใกล้ตัวได้ง่าย เพื่อผลิตสารสกัดสมุนไพรชนิดต่างๆ ออกจำหน่ายให้ผู้ผลิตเครื่องสำอางและงานเเฮนด์เมด
3) เจ้าของฟาร์ม สวนเกษตร เเหล่งเรียนรู้ชุมชน ผู้นำชุมชน ที่จะเรียนรู้การสกัดสมุนไพรเพื่อนำความรู้ไปต่อยอดขยายผลในชุมชน เพื่อสร้างแหล่งเรียนรู้ เเหล่งท่องเที่ยวเเนวใหม่ เชิงการให้ความรู้
4) ครู อาจารย์ หรือผู้ที่อยู่ในวงการการศึกษา ที่จะนำความรู้ไปขยายผลกับนักเรียนหรือหน่วยงานราชการ
5) บุคคลทั่วไปที่อยากจะสร้างคอร์สออนไลน์ หรืออยากสร้างตัวตนผ่านโลกออนไลน์ ในรูปแบบของการให้ความรู้การสกัดสมุนไพร ที่กำลังเป็นที่นิยมของผู้คน
6) คนทำงานประจำที่อยากจะค้นหาอาชีพเสริม
7) คนที่สนใจผลิตภัณฑ์เพื่อสุขภาพและความงาม
8) คนที่รู้กระเเสสมุนไพรไทยที่มาแรงและสร้างรายได้อย่างยั่งยืน
9) คนที่เห็นช่องทางตลาดขนาดใหญ่ และความน่าสนใจของผลิตภัณฑ์จากสมุนไพรไทย
10) คนที่อยากค้นหาตัวตน เเละความชอบ รวมถึงช่องทางสร้างรายได้จากสมุนไพร
ผู้เรียนต้องมีความรู้อะไรมาก่อน
ไม่จำเป็นต้องมีความรู้ หรือพื้นฐานใดๆ เพราะห้องเรียนนี้สอนตั้งแต่เริ่มต้น ปูพื้นฐานสำคัญ ไปจนถึงสอนสร้างองค์ความรู้แบบยั่งยืน จนสามารถต่อยอดได้จนถึงขั้นสูงสุด''',
};
const mockDataObject2 = {
  'title': 'ผลิตยาหม่องมณีพฤกษา ง่ายๆ ด้วยตัวเอง',
  'imageUrl': '$server/raot-document/images/aboutUs/aboutUs_232416392.png',
  'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
  'view': 500,
  'description':
      '''คอร์สสอนผลิตยาหม่องมณีพฤกษาด้วยตัวเอง ตํารับยาที่อยู่คู่ชาวไทยมาช้านาน ทำขายเองก็ได้ แจกฟรีตามงานก็ดี หรือจะส่งออกต่างประเทศก็ทำได้ หากคุณเรียนคอร์สนี้แล้ว คุณสามารถนําความรู้ที่ได้ไปประยุกต์ใช้เพื่อประกอบอาชีพเสริมได้
ประโยชน์ของคอร์สเรียน
- รู้ขั้นตอนทั้งหมด เพื่อให้สามารถผลิตยาหม่องมณีพฤกษาได้ด้วยตัวเอง
- สามารถนำความรู้ไปทำเป็นอาชีพได้
จำเป็นต้องมีความรู้ด้านใดมาก่อนหรือไม่
- ไม่จำเป็นต้องมีความรู้ด้านใดมาก่อนก็เรียนได้''',
};

const List<dynamic> mockDataClassFavoriteList = [];
const dynamic mockDataClassFavorite = {
  'title': 'เกษตร D.I.YOnline by Onsite เกษตรยุค New Normal',
  'imageUrl': '',
  'description':
      'เกษตร D.I.YOnline by Onsite เกษตรยุค New Normal เกษตร D.I.YOnline by Onsite เกษตรยุค New Normal เกษตร D.I.YOnline by Onsite เกษตรยุค New Normal',
};

final List<String> mockBannerList = [
  '$server/raot-document/images/event/event_230009649.png',
  '$server/raot-document/images/event/event_231013260.jpg',
  '$server/raot-document/images/event/event_230539141.jpg',
  '$server/raot-document/images/event/event_235223817.png',
];

mockCreateProfileData() {
  ManageStorage.createProfile(
    value: {
      'profileCode': '1',
      'firstName': 'ยุทธเลิศ',
      'lastName': 'สรณะ',
      'imageUrl':
          '$server/vet-document/images/employee/ff7ab024-5909-48c3-b421-4f0b1bbf8bf6/%E0%B8%AB%E0%B8%A1%E0%B8%B9%20%E0%B9%81%E0%B8%81%E0%B9%89.png',
    },
    key: 'guest',
  );
}

// ------- mock Booking -----------------------------------------------------------------------------

const mockFAQ = [
  {
    'code': '01',
    'title': 'FAQ หัวข้อที่ 1',
  },
  {
    'code': '02',
    'title': 'FAQ หัวข้อที่ 2',
  },
  {
    'code': '03',
    'title': 'FAQ หัวข้อที่ 3',
  },
  {
    'code': '04',
    'title': 'FAQ หัวข้อที่ 4',
  },
];

class MockContact {
  static mockContactCategoryList() {
    String img = 'http://122.155.223.63/td-doc/images/des/des_hall.png';
    dynamic data = [
      {
        'code': '',
        'title': 'เบอร์ศูนย์ทั่วประเทศ',
        'imageUrl': img,
        'description': 'ศูนยฯ์ใหญ่,ศูนย์ฯกทม.,ศูนย์ฯนนทบุรี,...',
        'total': '7',
      },
      {
        'code': '01',
        'title': 'เบอร์ติดต่อทั่วไป',
        'imageUrl': img,
        'description': 'กระทรวงดิจิตอลฯ,สำนักงานดิจิทัลเพื่อเศรษฐกิจ',
        'total': '2',
      },
      {
        'code': '02',
        'title': 'เบอร์ฉุกเฉิน',
        'imageUrl': img,
        'description': 'เจ็บป่วยฉุกเฉิน,สายด่วนการแพทย์,...',
        'total': '2',
      },
    ];
    return data;
  }

  static mockContactList() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String ranCode = String.fromCharCodes(Iterable.generate(
        12, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String img = 'http://122.155.223.63/td-doc/images/des/des_hall.png';
    List<dynamic> cat01 = [
      {
        'code': ranCode,
        'title': 'ศูนย์ฯใหญ่',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '',
        'description': '',
      },
      {
        'code': ranCode,
        'title': 'ศูนย์ฯกทม.',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '',
        'description': '',
      },
      {
        'code': ranCode,
        'title': 'ศูนย์ฯนนทบุรี',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '',
        'description': '',
      },
    ];

    List<dynamic> cat02 = [
      {
        'code': ranCode,
        'title': 'กระทรวงดิจิตอลฯ',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '01',
        'description': '',
      },
      {
        'code': ranCode,
        'title': 'สำนักงานดิจิทัลเพื่อเศรษฐกิจ.',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '01',
        'description': '',
      },
    ];
    List<dynamic> cat03 = [
      {
        'code': ranCode,
        'title': 'เจ็บป่วยฉุกเฉิน',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '02',
        'description': '',
      },
      {
        'code': ranCode,
        'title': 'สายด่วนการแพทย์.',
        'phone': '02 123 4568',
        'imageUrl': img,
        'category': '02',
        'description': '',
      },
    ];

    cat01.addAll(cat02);
    cat01.addAll(cat03);

    return cat01;
  }
}

class MockBookingData {
  static List<dynamic> category() => [
        {'code': '0', 'title': 'กำลังจะมาถึง'},
        {'code': '1', 'title': 'ประวัติการจอง'},
      ];
  static List<dynamic> booking() {
    final _random = new Random();
    var now = DateTime.now();
    var now1 = DateTime(now.year, now.month, now.day, now.hour + 1);
    var now3 = DateTime(now.year, now.month, now.day, now.hour + 3);

    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    List<dynamic> mockBookingData = [
      {
        'code': '23powjfskdlv',
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'dateTime': DateFormat('yyyyMMddHHmmss').format(now1),
        'center': '0',
        'checkIn': false,
      },
      {
        'code': 'wefjwep',
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'dateTime': DateFormat('yyyyMMddHHmmss').format(now3),
        'center': '0',
        'checkIn': false,
      },
    ];
    List<DateTime> listRandom = [
      DateTime(now.year, now.month + 1, _random.nextInt(28), 10, now.minute),
      DateTime(now.year, now.month + 1, _random.nextInt(28), 10, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 9, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 10, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 12, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 16, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 18, now.minute),
      DateTime(now.year, now.month, _random.nextInt(28), 20, now.minute),
      DateTime(now.year, now.month - 1, _random.nextInt(28), 12, now.minute),
      DateTime(now.year, now.month - 1, _random.nextInt(28), 12, now.minute),
    ];
    for (var i = 0; i < _random.nextInt(5) + 10; i++) {
      var element = listRandom[_random.nextInt(listRandom.length)];
      String ranCode = String.fromCharCodes(Iterable.generate(
          12, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

      mockBookingData = [
        {
          'code': ranCode,
          'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
          'dateTime': DateFormat('yyyyMMddHHmmss').format(element),
          'center': _random.nextInt(3).toString(),
          'checkIn': element.compareTo(now) >= 0 ? false : _random.nextBool(),
        },
        ...mockBookingData,
      ];
    }
    mockBookingData = [
      {
        'code': 'wwwwwwwwwwwwww',
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'dateTime': DateFormat('yyyyMMddHHmmss')
            .format(DateTime(now.year, now.month, now.day, 05, now.minute)),
        'center': '1',
        'checkIn': false,
      },
      {
        'code': 'xxxxxxx',
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'dateTime': DateFormat('yyyyMMddHHmmss')
            .format(DateTime(now.year, now.month, now.day, 06, now.minute)),
        'center': '1',
        'checkIn': true,
      },
      ...mockBookingData
    ];
    mockBookingData.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
    return mockBookingData;
  }

  static center() {
    const imageBooking =
        'https://gateway.we-builds.com/dnp-document/images/event/event_234210073.jpg';
    return [
      {
        'code': '0',
        'imageUrl': imageBooking,
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'count': 4,
      },
      {
        'code': '1',
        'imageUrl': imageBooking,
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'count': 3,
      },
      {
        'code': '2',
        'imageUrl': imageBooking,
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'count': 2,
      },
      {
        'code': '3',
        'imageUrl': imageBooking,
        'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน อำเภอบางใหญ่ นนทบุรี',
        'count': 14,
      },
    ];
  }

  static bookingReal() {
    return [
      {
        "bookingno": 20231114002,
        "userid": 1,
        "bookingdate": "2023-11-14T00:00:00",
        "status": "4",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "sdsd",
        "phone": "12212",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231117018,
        "userid": 1,
        "bookingdate": "2023-11-18T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "test insert 17/11/2023",
        "phone": "0931039230",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231122001,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "4",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "today 22/11/23",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231122013,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "4",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "เนื่องจากของเก่ามันหมดแล้วค่ะ",
        "phone": "0985946467",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231123005,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "test response",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231123006,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "test response",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231124002,
        "userid": 1,
        "bookingdate": "2023-11-25T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "12:00",
        "endTime": "14:00",
        "bookingDesc": "test",
        "phone": "888888888",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark":
            "ปริ้นเอกสาร|ใช้อินเทอร์เน็ต|สืบค้นข้อมูล|จัดอบรม|ถ่ายรูปสินค้า|ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231124005,
        "userid": 1,
        "bookingdate": "2023-11-24T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "13:00",
        "endTime": "14:00",
        "bookingDesc": "จอง24/11/2023",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231124006,
        "userid": 1,
        "bookingdate": "2023-11-24T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "จอง24/11/2023 13:00-14:00",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231127001,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "test 26/11/2023",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231127003,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "test insert 26/11/2023",
        "phone": "0931039231",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ประชุม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231127007,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "2",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบจองคอมพิวเตอร์เวลาเดียวกัน",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231127014,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "ซื้อลูกอม หิว",
        "phone": "0931039231",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ปริ้นเอกสาร|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231127015,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "ทดสอบจองพื้นที่",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ประชุม|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231121001,
        "userid": 1,
        "bookingdate": "2023-11-21T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "12:00",
        "endTime": "14:00",
        "bookingDesc": "string",
        "phone": "string",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231122004,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "cream 22/11/23 2",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231122007,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "13:00",
        "endTime": "14:00",
        "bookingDesc": "cream 22/11/23 5",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ถ่ายรูปสินค้า|ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231122010,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "cream 22/11/23 8",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark":
            "ประชุม|ปริ้นเอกสาร|สืบค้นข้อมูล|ใช้อินเทอร์เน็ต|จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231123007,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "test response",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231124004,
        "userid": 1,
        "bookingdate": "2023-11-25T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "12:00",
        "endTime": "13:00",
        "bookingDesc": "postpone booking",
        "phone": "4564564564",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231127006,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "จองพื้นที่เวลาเดียวกัน 2",
        "phone": "0958010390",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร|จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231127008,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบจองคอม 2",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231127010,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "จองพื้นที่1",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231127013,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "ทดสอบ",
        "phone": "0931039231",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "สืบค้นข้อมูล|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231128005,
        "userid": 121,
        "bookingdate": "2023-11-30T00:00:00",
        "status": "1",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "13:00",
        "endTime": "14:00",
        "bookingDesc": "test",
        "phone": "0616652550",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231128007,
        "userid": 118,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "1",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "ทดสอบจอง 28/11/2023",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร|จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231113003,
        "userid": 1,
        "bookingdate": "2023-11-13T00:00:00",
        "status": "2",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "ads",
        "phone": "111",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231121002,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "string",
        "phone": "string",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231121005,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "test insert remark",
        "phone": "0985946467",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ถ่ายรูปสินค้า|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231121006,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "test insert remark1",
        "phone": "0985946467",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231122002,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "4",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "cream 22/11/23",
        "phone": "0931039230",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม|ถ่ายรูปสินค้า|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231122003,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "cream 22/11/23 1",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231122005,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "cream 22/11/23 3",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231122006,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "12:00",
        "endTime": "13:00",
        "bookingDesc": "cream 22/11/23 4",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231122008,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "cream 22/11/23 6",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231122009,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "15:00",
        "endTime": "16:00",
        "bookingDesc": "cream 22/11/23 7 update 1",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231122012,
        "userid": 1,
        "bookingdate": "2023-11-22T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "ทดสอบวันนี้ 22/11/2023 update",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "จัดอบรม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231123001,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "08:00",
        "endTime": "09:00",
        "bookingDesc": "จองใหม่วันนี้ 23/11/2023",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "จัดอบรม|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231123009,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบ alert message",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231124008,
        "userid": 1,
        "bookingdate": "2023-11-24T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "จองห้องประชุมนะจ๊ะ",
        "phone": "00912",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231124009,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "2",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "จองคอม",
        "phone": "0091235551",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231124010,
        "userid": 1,
        "bookingdate": "2024-11-13T00:00:00",
        "status": "1",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "เนื่องจากของเก่ามันหมดแล้วค่ะ",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark":
            "ประชุม|สืบค้นข้อมูล|ใช้อินเทอร์เน็ต|ปริ้นเอกสาร|จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231127004,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบจองพื้นที่เวลาเดียวกัน",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "จัดอบรม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231127011,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "จองพื้นที่",
        "phone": "0985946467",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231128006,
        "userid": 118,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "13:00",
        "endTime": "14:00",
        "bookingDesc": "ทดสอบจองวันนี้ ",
        "phone": "0931039231",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231114001,
        "userid": 1,
        "bookingdate": "2023-11-14T00:00:00",
        "status": "2",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "asddas",
        "phone": "122121",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": null,
        "base64": null
      },
      {
        "bookingno": 20231124007,
        "userid": 1,
        "bookingdate": "2023-11-24T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "cream test booking today 24/11/222023",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "สืบค้นข้อมูล|จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231124011,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "4",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "จองห้องประชุม",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231124012,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "4",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "14:00",
        "endTime": "15:00",
        "bookingDesc": "จองห้องประชุมนะจ๊ะ",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231124013,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "จองห้องประชุมนะจ๊ะ2",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231124014,
        "userid": 1,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "13:00",
        "endTime": "14:00",
        "bookingDesc": "จองห้องประชุมนะจ๊ะ3",
        "phone": "0091235551",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "สืบค้นข้อมูล|ใช้อินเทอร์เน็ต",
        "base64": null
      },
      {
        "bookingno": 20231127002,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "12:00",
        "endTime": "13:00",
        "bookingDesc": "26/11/2023",
        "phone": "0931039231",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231127009,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบจองพื้นที่เวลาเดียวกัน 3",
        "phone": "0958010390",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231127012,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "เนื่องจากของเก่ามันหมดแล้วค่ะ",
        "phone": "0931039231",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ประชุม|ถ่ายรูปสินค้า",
        "base64": null
      },
      {
        "bookingno": 20231128002,
        "userid": 113,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "ทดสอบ",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231128003,
        "userid": 113,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "12:00",
        "endTime": "13:00",
        "bookingDesc": "28",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      },
      {
        "bookingno": 20231122015,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "16:00",
        "endTime": "17:00",
        "bookingDesc": "change to api folder test",
        "phone": "0931039230",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231123008,
        "userid": 1,
        "bookingdate": "2023-11-23T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "test response",
        "phone": "0931039231",
        "bookingSlotType": 2,
        "typeName": "จองใช้งานคอมพิวเตอร์",
        "remark": "ประชุม|สืบค้นข้อมูล",
        "base64": null
      },
      {
        "bookingno": 20231124001,
        "userid": 1,
        "bookingdate": "2023-11-24T00:00:00",
        "status": "1",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "11:00",
        "endTime": "12:00",
        "bookingDesc": "te",
        "phone": "0899999999",
        "bookingSlotType": 1,
        "typeName": "จองห้องประชุม",
        "remark": "ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231127005,
        "userid": 1,
        "bookingdate": "2023-11-27T00:00:00",
        "status": "0",
        "centerId": 1821,
        "centerName": "เชียงคาน",
        "centerAdd": "ตลาดคนเดิน เชียงคาน  เชียงคาน  เชียงคาน  เลย",
        "startTime": "10:00",
        "endTime": "11:00",
        "bookingDesc": "ทดสอบจองพื้นที่เวลาเดียวกัน 1",
        "phone": "0985946467",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "จัดอบรม",
        "base64": null
      },
      {
        "bookingno": 20231128001,
        "userid": 113,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 11,
        "centerName": "โรงเรียนบ้านกลาง",
        "centerAdd":
            "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง ตำบล แม่สลองนอก อำเภอ แม่ฟ้าหลวง จังหวัด เชียงราย",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "test booking postpone with new userid",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร|ประชุม",
        "base64": null
      },
      {
        "bookingno": 20231128004,
        "userid": 113,
        "bookingdate": "2023-11-28T00:00:00",
        "status": "0",
        "centerId": 1,
        "centerName": "โรงเรียนบ้านหนองบัว",
        "centerAdd":
            "หมู่ที่ 15 ตำบล บ้านเดื่อ อำเภอ เกษตรสมบูรณ์ จังหวัด ชัยภูมิ",
        "startTime": "09:00",
        "endTime": "10:00",
        "bookingDesc": "28/11/2023",
        "phone": "0931039230",
        "bookingSlotType": 21,
        "typeName": "จองพื้นที่",
        "remark": "ปริ้นเอกสาร",
        "base64": null
      }
    ];
  }

  static centerReal() {
    return [
      {
        "centerName": "โรงเรียนบ้านหนองบัว",
        "taId": 360403,
        "centerDesc": null,
        "centerAdd": "หมู่ที่ 15",
        "centerId": 1,
        "slotCount": 1,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0000000000",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1,
            "photoname": "ONDE0525-8886",
            "photoId": 142,
            "isFlag": true,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0525\\ONDE0525-8886.jpg",
            "center": null
          },
          {
            "centerId": 1,
            "photoname": "ONDE0525-8887",
            "photoId": 143,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0525\\ONDE0525-8887.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "เชียงคาน",
        "taId": 420301,
        "centerDesc": null,
        "centerAdd": "ตลาดคนเดิน เชียงคาน",
        "centerId": 1821,
        "slotCount": 2,
        "centerWebsite": "https://chillpainai.com/scoop/8241",
        "centerFacebook": "https://www.facebook.com/groups/303721741080612",
        "centerTel": "0999999999",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1821,
            "photoname": "0001-8881",
            "photoId": 122,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/0001/0001-8881.jpeg",
            "center": null
          },
          {
            "centerId": 1821,
            "photoname": "0001-8880",
            "photoId": 121,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/0001/0001-8880.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "โรงเรียนบ้านกลาง",
        "taId": 571503,
        "centerDesc": null,
        "centerAdd": "16 หมู่ที่ 6 ถนนป่าซาง-ดอยแม่สลอง บ้านกลาง",
        "centerId": 11,
        "slotCount": 7,
        "centerWebsite": "www.google.com",
        "centerFacebook": "www.facebook.com",
        "centerTel": "0952531911",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 11,
            "photoname": "ONDE0535-8878",
            "photoId": 104,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0535\\ONDE0535-8878.jpg",
            "center": null
          },
          {
            "centerId": 11,
            "photoname": "ONDE0535-8879",
            "photoId": 105,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0535\\ONDE0535-8879.jpg",
            "center": null
          },
          {
            "centerId": 11,
            "photoname": "ONDE0535-8883",
            "photoId": 124,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0535\\ONDE0535-8883.jpg",
            "center": null
          },
          {
            "centerId": 11,
            "photoname": "ONDE0535-8884",
            "photoId": 125,
            "isFlag": true,
            "photo": "C:\\File_ATTACHMENT\\Center\\ONDE0535\\ONDE0535-8884.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "โรงเรียนบ้านสันหีบ",
        "taId": 640503,
        "centerDesc": null,
        "centerAdd": "หมู่ 8",
        "centerId": 81,
        "slotCount": 10,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "โรงเรียนอนุบาลโชคชัย(บ้านแม่เลียบแม่บง)",
        "taId": 571802,
        "centerDesc": null,
        "centerAdd": "หมู่ 2",
        "centerId": 12,
        "slotCount": 0,
        "centerWebsite": "https://mui.com/material-ui/api/icon/",
        "centerFacebook": "https://mui.com/material-ui/api/icon/",
        "centerTel": "0778889999",
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "โรงเรียนไกรในวิทยาคม รัชมังคลาภิเษก",
        "taId": 640405,
        "centerDesc": null,
        "centerAdd": "เลขที่ 180 หมู่ 3",
        "centerId": 82,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "มุกดาหาร",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd":
            "ผ้าทอมือบ้านเป้า. ศาลากลางจังหวัดมุกดาหาร ถนนวิวิธสุรการ อำเภอเมืองมุกดาหาร จังหวัดมุกดาหาร 49000",
        "centerId": 1743,
        "slotCount": 0,
        "centerWebsite": "https://m.mukdahan.go.th/",
        "centerFacebook": "https://m.mukdahan.go.th/",
        "centerTel": "02199988",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1743,
            "photoname": "ONDE5555-8822",
            "photoId": 21,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONDE5555/ONDE5555-8822",
            "center": null
          },
          {
            "centerId": 1743,
            "photoname": "ONDE5555-8824",
            "photoId": 22,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONDE5555/ONDE5555-8824",
            "center": null
          }
        ]
      },
      {
        "centerName": "Icon Siam",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd": "Address. 333, Moo 7, Ban Kham Phaknok ",
        "centerId": 1744,
        "slotCount": 0,
        "centerWebsite": "https://www.google.com/search?q=mukdahan",
        "centerFacebook": "https://www.google.com/search?q=mukdahan",
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "Icon Siam test",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd": "Address. 333, Moo 7, Ban Kham Phaknok ",
        "centerId": 1745,
        "slotCount": 0,
        "centerWebsite": "https://www.google.com/search?q=mukdahan",
        "centerFacebook": "https://www.google.com/search?q=mukdahan",
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "Kampalai test",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd": "Kampalai A. Muang, Mukdahan 49000 Thailand.",
        "centerId": 1747,
        "slotCount": 0,
        "centerWebsite":
            "https://www.tripadvisor.com/Hotel_Review-g664845-d14984622-Reviews-Suanpalm_Healthy_Resort-Mukdahan_Mukdahan_Province.html",
        "centerFacebook":
            "https://www.tripadvisor.com/Hotel_Review-g664845-d14984622-Reviews-Suanpalm_Healthy_Resort-Mukdahan_Mukdahan_Province.html",
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "Kampalai test testtes",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd": "Kampalai A. Muang, Mukdahan 49000 Thailand.",
        "centerId": 1748,
        "slotCount": 0,
        "centerWebsite":
            "https://www.tripadvisor.com/Hotel_Review-g664845-d14984622-Reviews-Suanpalm_Healthy_Resort-Mukdahan_Mukdahan_Province.html",
        "centerFacebook":
            "https://www.tripadvisor.com/Hotel_Review-g664845-d14984622-Reviews-Suanpalm_Healthy_Resort-Mukdahan_Mukdahan_Province.html",
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "Bangsaiyai",
        "taId": 270306,
        "centerDesc": null,
        "centerAdd":
            "หมู่ที่  1  บ้านบางทรายใหญ่ ตำบลบางทรายใหญ่ อำเภอเมืองมุกดาหาร จังหวัดมุกดาหาร 49000",
        "centerId": 1749,
        "slotCount": 0,
        "centerWebsite":
            "https://data.bopp-obec.info/web/index_view.php?School_ID=1049730047&page=info",
        "centerFacebook":
            "https://data.bopp-obec.info/web/index_view.php?School_ID=1049730047&page=info",
        "centerTel": null,
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "Nongna6",
        "taId": 110602,
        "centerDesc": null,
        "centerAdd": "test",
        "centerId": 1766,
        "slotCount": 0,
        "centerWebsite": "https://m.mukdahan.go.th/?p=5760",
        "centerFacebook": "https://m.mukdahan.go.th/?p=5760",
        "centerTel": "0999999999",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1766,
            "photoname": "ONE04446-8836",
            "photoId": 37,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04446/ONE04446-8836.jpg",
            "center": null
          },
          {
            "centerId": 1766,
            "photoname": "ONE04446-8837",
            "photoId": 38,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04446/ONE04446-8837.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "บ้านหนองหอย",
        "taId": 490104,
        "centerDesc": null,
        "centerAdd":
            "ถนน3040 ตำบลบางทรายใหญ่ อำเภอเมืองมุกดาหาร จังหวัดมุกดาหาร",
        "centerId": 1767,
        "slotCount": 0,
        "centerWebsite":
            "https://www.yellowpages.co.th/profile/%E0%B8%9A%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%AB%E0%B8%99%E0%B8%AD%E0%B8%87%E0%B8%AB%E0%B8%AD%E0%B8%A2-naddPG",
        "centerFacebook":
            "https://www.yellowpages.co.th/profile/%E0%B8%9A%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%AB%E0%B8%99%E0%B8%AD%E0%B8%87%E0%B8%AB%E0%B8%AD%E0%B8%A2-naddPG",
        "centerTel": "0988888888",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1767,
            "photoname": "ONE04447-8838",
            "photoId": 39,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04447/ONE04447-8838.jpeg",
            "center": null
          },
          {
            "centerId": 1767,
            "photoname": "ONE04447-8839",
            "photoId": 40,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04447/ONE04447-8839.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "Nongna888",
        "taId": 110602,
        "centerDesc": null,
        "centerAdd": "test",
        "centerId": 1768,
        "slotCount": 0,
        "centerWebsite": "https://m.mukdahan.go.th/?p=5760",
        "centerFacebook": "https://m.mukdahan.go.th/?p=5760",
        "centerTel": "0844744454",
        "base64": null,
        "tblCenterPhotos": []
      },
      {
        "centerName": "ซีอ็ด บิ๊กซี",
        "taId": 490104,
        "centerDesc": null,
        "centerAdd": "บิ๊กซีซุปเปอร์เซ็นเตอร์มุกดาหาร",
        "centerId": 1769,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0999999999",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1769,
            "photoname": "ONE04448-8843",
            "photoId": 44,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04448/ONE04448-8843.png",
            "center": null
          },
          {
            "centerId": 1769,
            "photoname": "ONE04448-8844",
            "photoId": 45,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04448/ONE04448-8844.png",
            "center": null
          },
          {
            "centerId": 1769,
            "photoname": "ONE04448-8840",
            "photoId": 41,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04448/ONE04448-8840.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ศูนย์ดิจิทัลชุมชนกศน. ท่าแดง",
        "taId": 341101,
        "centerDesc": null,
        "centerAdd": "อุบลราชธานี",
        "centerId": 1770,
        "slotCount": 0,
        "centerWebsite": "ทดสอบ",
        "centerFacebook": "ทดสอบ",
        "centerTel": "0895558822",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1770,
            "photoname": "44444-8841",
            "photoId": 42,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\44444\\44444-8841.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "Tester center",
        "taId": 103001,
        "centerDesc": null,
        "centerAdd": "ม ธรรมศาสตร์",
        "centerId": 1771,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0865322525",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1771,
            "photoname": "2154255114-8842",
            "photoId": 43,
            "isFlag": true,
            "photo":
                "C:\\File_ATTACHMENT\\Center\\2154255114\\2154255114-8842.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "cream",
        "taId": 490104,
        "centerDesc": null,
        "centerAdd": "มุกดาหาร",
        "centerId": 1772,
        "slotCount": 0,
        "centerWebsite": "www.google.com",
        "centerFacebook": "www.facebook.com",
        "centerTel": "0714444444",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1772,
            "photoname": "0545145-8845",
            "photoId": 46,
            "isFlag": true,
            "photo": "C:\\File_ATTACHMENT\\Center\\0545145\\0545145-8845.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ศูนย์อะไรสักอย่าง",
        "taId": 101803,
        "centerDesc": null,
        "centerAdd": "ฮานอย",
        "centerId": 1773,
        "slotCount": 0,
        "centerWebsite": "www.test.com",
        "centerFacebook": "www.facebook.com",
        "centerTel": "0000",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1773,
            "photoname": "0000-8846",
            "photoId": 47,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\0000\\0000-8846.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ตลาดอินโดจีน",
        "taId": 110602,
        "centerDesc": null,
        "centerAdd": "ตลาดอินโดจีน",
        "centerId": 1774,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0989898989",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1774,
            "photoname": "1122-8847",
            "photoId": 48,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/1122/1122-8847.png",
            "center": null
          },
          {
            "centerId": 1774,
            "photoname": "1122-8848",
            "photoId": 49,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/1122/1122-8848.png",
            "center": null
          },
          {
            "centerId": 1774,
            "photoname": "1122-8850",
            "photoId": 51,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/1122/1122-8850.png",
            "center": null
          },
          {
            "centerId": 1774,
            "photoname": "1122-8849",
            "photoId": 50,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/1122/1122-8849.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ภูมโนรมณ์",
        "taId": 490101,
        "centerDesc": null,
        "centerAdd": "ตลาดราตรี",
        "centerId": 1775,
        "slotCount": 0,
        "centerWebsite":
            "https://thailandtourismdirectory.go.th/attraction/865",
        "centerFacebook":
            "https://thailandtourismdirectory.go.th/attraction/865",
        "centerTel": "0999989999",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1775,
            "photoname": "ONE04449-8863",
            "photoId": 64,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/ONE04449/ONE04449-8863.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "ครีมทดสอบ",
        "taId": 130505,
        "centerDesc": null,
        "centerAdd": "เชียงใหม่",
        "centerId": 1776,
        "slotCount": 0,
        "centerWebsite": "www.chiangrai.com",
        "centerFacebook": "www.facebook-chiangrai.com",
        "centerTel": "0000000000",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1776,
            "photoname": "0000-8855",
            "photoId": 56,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\0000\\0000-8855.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ศูนย์ดิจิทัลชุมชน โรงเรียนคลองทรงกระเทียม",
        "taId": 103801,
        "centerDesc": null,
        "centerAdd":
            "34 ซอย นาคนิวาส 2 แขวงลาดพร้าว เขตลาดพร้าว กรุงเทพมหานคร 10230",
        "centerId": 1777,
        "slotCount": 0,
        "centerWebsite":
            "http://localhost:8081/backoffice/officedigital/inform?m=add",
        "centerFacebook":
            "http://localhost:8081/backoffice/officedigital/inform?m=add",
        "centerTel": "0985662255",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1777,
            "photoname": "15510-8858",
            "photoId": 59,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\15510\\15510-8858.png",
            "center": null
          },
          {
            "centerId": 1777,
            "photoname": "15510-8859",
            "photoId": 60,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\15510\\15510-8859.png",
            "center": null
          },
          {
            "centerId": 1777,
            "photoname": "15510-8856",
            "photoId": 57,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\15510\\15510-8856.png",
            "center": null
          },
          {
            "centerId": 1777,
            "photoname": "15510-8857",
            "photoId": 58,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\15510\\15510-8857.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "Test Center",
        "taId": 130601,
        "centerDesc": null,
        "centerAdd": "bts คูคต",
        "centerId": 1780,
        "slotCount": 0,
        "centerWebsite": "www.test.com",
        "centerFacebook": null,
        "centerTel": "0982341231",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1780,
            "photoname": "TEST001-8870",
            "photoId": 82,
            "isFlag": true,
            "photo":
                "/Users/istnn/Documents/GitHub/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/TEST001/TEST001-8870.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "ศูนย์ดำรงค์ธรรม",
        "taId": 110602,
        "centerDesc": null,
        "centerAdd": "สมุทรปราการ",
        "centerId": 1781,
        "slotCount": 0,
        "centerWebsite": "https://meet.google.com/?authuser=3",
        "centerFacebook": "https://meet.google.com/?authuser=3",
        "centerTel": "0985558552",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1781,
            "photoname": "DAM15444-8871",
            "photoId": 83,
            "isFlag": true,
            "photo": "C:\\File_ATTACHMENT\\Center\\DAM15444\\DAM15444-8871.png",
            "center": null
          },
          {
            "centerId": 1781,
            "photoname": "DAM15444-8874",
            "photoId": 86,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\DAM15444\\DAM15444-8874.png",
            "center": null
          },
          {
            "centerId": 1781,
            "photoname": "DAM15444-8873",
            "photoId": 85,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\DAM15444\\DAM15444-8873.jpg",
            "center": null
          },
          {
            "centerId": 1781,
            "photoname": "DAM15444-8872",
            "photoId": 84,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\DAM15444\\DAM15444-8872.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "supper computer",
        "taId": 490104,
        "centerDesc": null,
        "centerAdd": "ตลาดราตรี",
        "centerId": 1801,
        "slotCount": 0,
        "centerWebsite": "https://localhost:7236/swagger/index.html",
        "centerFacebook": "https://localhost:7236/swagger/index.html",
        "centerTel": "3333333333",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1801,
            "photoname": "3333-8877",
            "photoId": 103,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/3333/3333-8877.jpg",
            "center": null
          },
          {
            "centerId": 1801,
            "photoname": "3333-8876",
            "photoId": 102,
            "isFlag": false,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/3333/3333-8876.jpg",
            "center": null
          },
          {
            "centerId": 1801,
            "photoname": "3333-8875",
            "photoId": 101,
            "isFlag": true,
            "photo":
                "/Users/ploysuda/Documents/Synergy/Projects/DCC-Portal-API/dcc-dotnet-api/C:/File_ATTACHMENT/Center/3333/3333-8875.png",
            "center": null
          }
        ]
      },
      {
        "centerName": "โรงเรียนบ้านหนองดูน",
        "taId": 342001,
        "centerDesc": null,
        "centerAdd": "โรงเรียนบ้านหนองดูนโนนค้อหนองหัวลิง",
        "centerId": 1822,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0999999999",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1822,
            "photoname": "ODE11201-8882",
            "photoId": 123,
            "isFlag": false,
            "photo": "C:\\File_ATTACHMENT\\Center\\ODE11201\\ODE11201-8882.jpg",
            "center": null
          },
          {
            "centerId": 1822,
            "photoname": "ODE11201-8885",
            "photoId": 126,
            "isFlag": true,
            "photo": "C:\\File_ATTACHMENT\\Center\\ODE11201\\ODE11201-8885.jpg",
            "center": null
          }
        ]
      },
      {
        "centerName": "ศูนย์ดิจิทัลชุมชมบ้านท่าแดง",
        "taId": 140501,
        "centerDesc": null,
        "centerAdd": "บ้านม่วงสามสิบ",
        "centerId": 1841,
        "slotCount": 0,
        "centerWebsite": null,
        "centerFacebook": null,
        "centerTel": "0898655454",
        "base64": null,
        "tblCenterPhotos": [
          {
            "centerId": 1841,
            "photoname": "ODE112500-8888",
            "photoId": 144,
            "isFlag": true,
            "photo":
                "C:\\File_ATTACHMENT\\Center\\ODE112500\\ODE112500-8888.jpg",
            "center": null
          }
        ]
      }
    ];
  }
}

const List<dynamic> mockDataCertificateList = [
  {
    'title': 'CERTIHCATE OF ACHIEVEMENT',
    'imageUrl':
        'https://page.hrteamwork.com/wp-content/uploads/2020/11/cer.jpg',
    'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
    'view': 500,
    'description': '',
  },
  {
    'title': 'มาตรฐาน ผู้ควบคุมเครนรถบรรทุกขนส่ง',
    'imageUrl':
        'https://www.bhumisiam.com/wp-content/uploads/2017/01/micropile-ผู้ควบคุมปั้นจั่น-Certificate-1-1030x728.jpg',
    'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
    'view': 500,
    'description': '',
  },
  {
    'title': 'มาตรฐาน ผู้ควบคุมปั้นจั่น',
    'imageUrl':
        'https://www.bhumisiam.com/wp-content/uploads/2017/01/micropile-ผู้ควบคุมเครนรถบรรทุกขนส่ง-Certificate-1-1030x728.jpg',
    'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
    'view': 500,
    'description':
        'อบรมเครน (Crane) ตามกฎหมาย 2552 - 2564 หรืออบรมปั้นจั่น เป็นหลักสูตรการอบรมสำหรับผู้ที่ทำงานร่วมกับการใช้เครนหรือปั้นจั่นตามราชกิจจานุเบกษา เผยแพร่กฎกระทรวงแรงงาน เกี่ยวกับการกำหนดให้นายจ้างบริหาร จัดการและดำเนินการด้านความปลอดภัย อาชีวอนามัย และสภาพแวดล้อมในการทำงาน ให้เป็นไปตามมาตรฐานที่กำหนดในกฎกระทรวงและเพื่อให้การทำงานเกี่ยวกับเครื่องจักร ปั้นจั่น และหม้อน้ำ ให้มีมาตรฐาน อันจะทำให้ลูกจ้างมีความปลอดภัยในการทำงานมากขึ้น อบรมได้ทั้งเขต ชลบุรี บางแสน และระยอง สอบใบเซอร์ปั้นจั่น ใบเซอร์เครน กฎหมายทบทวนปั้นจั่น อบรมทบทวนปั้นจั่น กฎหมาย อบรม เครน ทุก 2 ปีที่เซฟตี้อินไทย',
  },
];

const List<dynamic> mockDataApplyJobList = [
  {
    'title': 'พนักงานฝ่ายผลิต',
    'title2': 'บริษัท  แชมป์กบินทร์  จำกัด',
    'hour': 1,
    'date': '20220911',
    'time': '09.00'
  },
  {
    'title': 'พนักงานขับรถส่งสินค้า',
    'title2': 'บริษัท อินชา บีฟ จำกัด',
    'hour': 2,
    'date': '20220911',
    'time': '10.00'
  },
  {
    'title': 'คอมพิวเตอร์ กราฟฟิค',
    'title2': 'บริษัท ไทยพิพัฒน์ทูล แอนด์ โฮมมาร์ท จำกัด',
    'hour': 3,
    'date': '20220911',
    'time': '11.00'
  },
  {
    'title': 'QC ไลน์ผลิต',
    'title2': 'บริษัท สานิตแอนด์ซันส์ จำกัด (สาขานครนายก)',
    'hour': 4,
    'date': '20220911',
    'time': '12.00'
  },
];
