import 'package:flutter/services.dart';
import 'package:vkget/types.dart';
import 'package:vkget/vkget.dart';

extension VKGetExecute on VKGet {
  Future<VKGetResponse> execute(
    String scriptName,
    Map<String, dynamic> data, {
    bool oauth = false,
    bool isTraced = true,
    bool lazyInterpretation = false,
  }) async {
    return call(
      'execute',
      <String, dynamic>{
        'code': await rootBundle.loadString('vkscript/$scriptName.vks'),
        ...data,
      },
      oauth: oauth,
      isTraced: isTraced,
      lazyInterpretation: lazyInterpretation,
    );
  }
}
