import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppMasks {
  static final date = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );
}