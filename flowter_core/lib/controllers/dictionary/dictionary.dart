library dictionary;

import 'package:flowter_core/classes/language.dart';
import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/io/memory/memory.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../functions/transform_map.dart';

part '_controller.dart';
part '_language_direction.dart';
part '_statement_extension.dart';

part '_dictionary_reference/dictionary_reference.dart';
part '_dictionary_reference/excel_sheet_dictionary_reference.dart';
part '_dictionary_reference/key_to_language_to_statement_map_dictionary_reference.dart';
part '_dictionary_reference/language_to_key_to_statement_map_dictionary_reference.dart';
