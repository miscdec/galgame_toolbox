import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/link.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool selected = true;
  String? comboboxValue;

  String? _tempDirectory = 'Unknown';
  String? _downloadsDirectory = 'Unknown';
  String? _appSupportDirectory = 'Unknown';
  String? _appCacheDirectory = 'Unknown';
  String? _documentsDirectory = 'Unknown';

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  // final PathProviderLinux _provider = PathProviderLinux();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDirectories();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
              _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
              _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
              _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectories() async {
    Directory? tempDirectory;
    Directory? downloadsDirectory;
    Directory? appSupportDirectory;
    Directory? appCacheDirectory;
    Directory? documentsDirectory;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      tempDirectory = await getTemporaryDirectory();
    } on PlatformException {
      tempDirectory = null;
    }
    try {
      downloadsDirectory = await getDownloadsDirectory();
    } on PlatformException {
      downloadsDirectory = null;
    }

    try {
      documentsDirectory = await getApplicationDocumentsDirectory();
    } on PlatformException {
      documentsDirectory = null;
    }

    try {
      appSupportDirectory = await getApplicationSupportDirectory();
    } on PlatformException {
      appSupportDirectory = null;
    }

    try {
      appCacheDirectory = await getApplicationCacheDirectory();
    } on PlatformException {
      appCacheDirectory = null;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _tempDirectory = tempDirectory?.path ?? 'Unknown';
      _downloadsDirectory = downloadsDirectory?.path ?? 'Unknown';
      _appSupportDirectory = appSupportDirectory?.path ?? 'Unknown';
      _appCacheDirectory = appCacheDirectory?.path ?? 'Unknown';
      _documentsDirectory = documentsDirectory?.path ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Fluent UI for Flutter Showcase App'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Link(
            uri: Uri.parse('https://github.com/bdlukaa/fluent_ui'),
            builder: (context, open) => Semantics(
              link: true,
              child: Tooltip(
                message: 'Source code',
                child: IconButton(
                  icon: const Icon(FluentIcons.open_source, size: 24.0),
                  onPressed: open,
                ),
              ),
            ),
          ),
        ]),
      ),
      children: [
        const SizedBox(height: 22.0),
        Row(children: [
          Text('SPONSORS', style: theme.typography.bodyStrong),
          const SizedBox(width: 4.0),
          const Icon(FluentIcons.heart_fill, size: 16.0),
        ]),
        const SizedBox(height: 4.0),
        Text('CONTRIBUTORS', style: theme.typography.bodyStrong),
        const SizedBox(height: 4.0),
        Text('DIRECTORIES'),
        const SizedBox(height: 4.0),
        ListTile(
          title: const Text('Temp Directory'),
          subtitle: Text('$_tempDirectory'),
        ),
        ListTile(
          title: const Text('Documents Directory'),
          subtitle: Text('$_documentsDirectory'),
        ),
        ListTile(
          title: const Text('Downloads Directory'),
          subtitle: Text('$_downloadsDirectory'),
        ),
        ListTile(
          title: const Text('Application Support Directory'),
          subtitle: Text('$_appSupportDirectory'),
        ),
        ListTile(
          title: const Text('Application Cache Directory'),
          subtitle: Text('$_appCacheDirectory'),
        ),
        const SizedBox(height: 4.0),
        Text(_getAppBarTitle()),
        const SizedBox(height: 4.0),
        ..._deviceData.keys.map(
              (String property) {
            return Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    property,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${_deviceData[property]}',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ],
    );
  }

  String _getAppBarTitle() => kIsWeb
      ? 'Web Browser info'
      : switch (defaultTargetPlatform) {
    TargetPlatform.android => 'Android Device Info',
    TargetPlatform.iOS => 'iOS Device Info',
    TargetPlatform.linux => 'Linux Device Info',
    TargetPlatform.windows => 'Windows Device Info',
    TargetPlatform.macOS => 'MacOS Device Info',
    TargetPlatform.fuchsia => 'Fuchsia Device Info',
  };
}
