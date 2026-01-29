import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class SpreadsheetDecoderExample extends StatefulWidget {
  const SpreadsheetDecoderExample({super.key});

  @override
  State<SpreadsheetDecoderExample> createState() =>
      _SpreadsheetDecoderExampleState();
}

class _SpreadsheetDecoderExampleState extends State<SpreadsheetDecoderExample> {
  String _output = 'Tap "Run demo" to decode a tiny in-memory .xlsx file.';
  bool _busy = false;

  Future<void> _runDemo() async {
    setState(() {
      _busy = true;
      _output = 'Generating .xlsx bytes...';
    });

    try {
      final bytes = _createMinimalXlsxBytes();

      final decoder = SpreadsheetDecoder.decodeBytes(bytes);
      final sheetNames = decoder.tables.keys.toList()..sort();
      if (sheetNames.isEmpty) {
        throw StateError('No sheets found in generated xlsx');
      }

      final sb = StringBuffer();
      sb.writeln('Decoded tables: ${sheetNames.join(', ')}');
      sb.writeln('');

      for (final name in sheetNames) {
        final table = decoder.tables[name]!;
        sb.writeln('== $name ==');
        sb.writeln('maxRows=${table.maxRows}, maxCols=${table.maxCols}');
        sb.writeln('rows:');
        for (var r = 0; r < table.rows.length; r++) {
          sb.writeln('  $r: ${table.rows[r]}');
        }
        sb.writeln('');
      }

      setState(() {
        _output = sb.toString().trimRight();
      });
    } catch (e, st) {
      setState(() {
        _output = 'Error: $e\n\n$st';
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  /// Creates a minimal XLSX (zip) in-memory with one sheet:
  /// A1="Hello", B1=42, A2="World"
  Uint8List _createMinimalXlsxBytes() {
    const contentTypes = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
</Types>
''';

    const rootRels = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
''';

    const workbook = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
          xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="Sheet1" sheetId="1" r:id="rId1"/>
  </sheets>
</workbook>
''';

    const workbookRels = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>
</Relationships>
''';

    // Two shared strings: 0="Hello", 1="World"
    const sharedStrings = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="2" uniqueCount="2">
  <si><t>Hello</t></si>
  <si><t>World</t></si>
</sst>
''';

    // Minimal styles so parsers are happy.
    const styles = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="1"><font/></fonts>
  <fills count="1"><fill/></fills>
  <borders count="1"><border/></borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
</styleSheet>
''';

    const sheet1 = r'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
           xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheetData>
    <row r="1">
      <c r="A1" t="s"><v>0</v></c>
      <c r="B1"><v>42</v></c>
    </row>
    <row r="2">
      <c r="A2" t="s"><v>1</v></c>
    </row>
  </sheetData>
</worksheet>
''';

    final archive = Archive()
      ..addFile(ArchiveFile('[Content_Types].xml', contentTypes.length,
          utf8.encode(contentTypes)))
      ..addFile(ArchiveFile('_rels/.rels', rootRels.length, utf8.encode(rootRels)))
      ..addFile(ArchiveFile('xl/workbook.xml', workbook.length, utf8.encode(workbook)))
      ..addFile(ArchiveFile('xl/_rels/workbook.xml.rels', workbookRels.length,
          utf8.encode(workbookRels)))
      ..addFile(ArchiveFile('xl/sharedStrings.xml', sharedStrings.length,
          utf8.encode(sharedStrings)))
      ..addFile(
          ArchiveFile('xl/styles.xml', styles.length, utf8.encode(styles)))
      ..addFile(ArchiveFile('xl/worksheets/sheet1.xml', sheet1.length,
          utf8.encode(sheet1)));

    final zipped = ZipEncoder().encode(archive);
    return Uint8List.fromList(zipped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpreadsheetDecoder Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _busy ? null : _runDemo,
              child: Text(_busy ? 'Running...' : 'Run demo'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    _output,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

