import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProcessImage {

   filePath(String imgPath) async {
    var response = await http.get(imgPath);
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(join(documentDirectory.path, 'image.png'));
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }
}