import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'request_form_widgets.dart';

class RequestDocumentsTab extends StatefulWidget {
  final String entityName;
  const RequestDocumentsTab({super.key, this.entityName = "record"});

  @override
  State<RequestDocumentsTab> createState() => RequestDocumentsTabState();
}

class RequestDocumentsTabState
    extends _BaseDocumentsTabState<RequestDocumentsTab> {
  @override
  String get entityName => widget.entityName;
}

abstract class _BaseDocumentsTabState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String get entityName;

  final List<Map<String, String>> _documents = [];

  List<String> validate() {
    final missing = <String>[];
    return missing;
  }

  Future<void> _pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      String fileName = result.files.single.name;
      setState(() {
        _documents[index]['fileName'] = fileName;
      });
    }
  }

  Map<String, dynamic> getData() {
    return {
      "documents": _documents,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Documents Tab"),
          const SizedBox(height: 6),
          FormTabDescription(
            "Documents Tab records the $entityName's document details and information, which helps manage documentation within the system.",
          ),
          const SizedBox(height: 20),
          if (_documents.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  ..._documents.asMap().entries.map((entry) {
                    return _buildDocumentCard(entry.key);
                  }),
                ],
              ),
            ),
          if (_documents.isNotEmpty) const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  _documents.add({'label': '', 'fileName': ''});
                });
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                "Add Document",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Document ${index + 1}",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _documents.removeAt(index)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Label *",
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (val) {
              _documents[index]['label'] = val;
            },
          ),
          const SizedBox(height: 16),
          Text(
            "Add Supporting Document",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2181FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () => _pickFile(index),
              child: Text(
                "Choose File",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_documents[index]['fileName']?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text(
              "Selected: ${_documents[index]['fileName']}",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.green),
            )
          ]
        ],
      ),
    );
  }
}
