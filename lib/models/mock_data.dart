import 'dart:math';

import 'package:des/shared/secure_storage.dart';
import 'package:intl/intl.dart';

const List<dynamic> mockDataList = [
  mockDataObject1,
  mockDataObject2,
];
const dynamic mockDataObject1 = {
  'title': 'สกัดสมุนไพร เพื่อผลิตภัณฑ์เสริมความงาม',
  'imageUrl':
      'https://raot.we-builds.com/raot-document/images/aboutUs/aboutUs_232327200.png',
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
  'imageUrl':
      'https://raot.we-builds.com/raot-document/images/aboutUs/aboutUs_232416392.png',
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
  'https://raot.we-builds.com/raot-document/images/event/event_230009649.png',
  'https://raot.we-builds.com/raot-document/images/event/event_231013260.jpg',
  'https://raot.we-builds.com/raot-document/images/event/event_230539141.jpg',
  'https://raot.we-builds.com/raot-document/images/event/event_235223817.png',
];

mockCreateProfileData() {
  ManageStorage.createProfile(
    value: {
      'profileCode': '1',
      'firstName': 'ยุทธเลิศ',
      'lastName': 'สรณะ',
      'imageUrl':
          'https://vetweb.we-builds.com/vet-document/images/employee/ff7ab024-5909-48c3-b421-4f0b1bbf8bf6/%E0%B8%AB%E0%B8%A1%E0%B8%B9%20%E0%B9%81%E0%B8%81%E0%B9%89.png',
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
    const imageBooking = 'http://122.155.223.63/td-doc/images/des/des_hall.png';
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
    'description': '',
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
