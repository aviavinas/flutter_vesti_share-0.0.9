# flutter_vesti_share

Flutter Plugin for sharing contents to social media.

## Getting Started

add `flutter_vesti_share` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Please check the latest version before installation.
```
dependencies:
  flutter:
    sdk: flutter
  flutter_vesti_share:
    path: ../flutter_vesti_share/
``` 

## Usage

#### Add the following imports to your Dart code:

```
import 'package:flutter_vesti_share/flutter_vesti_share.dart';
```
## Methods

#### whatsAppImageList({List? paths, bool? business})
#### whatsAppText({String msg = '', String phone = '', bool? business = false,bool? useCallShareCenter = false}) 

## Example

```
List<dynamic> paths = [];
List<dynamic> urls = [
    "https://blurha.sh/assets/images/img1.jpg",
    "https://blurha.sh/assets/images/img1.jpg"
];
for(final url in urls){
    File file = await DefaultCacheManager().getSingleFile(url);
    paths.add(file.path);
}
await Share().whatsAppImageList(
    paths: paths,
    business: false
);

```

```
await Share().whatsAppText(
    msg: "Hi",
    phone: "5511954976161",
    business: false
);
```

