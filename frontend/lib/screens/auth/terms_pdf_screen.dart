import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsPdfScreen extends StatefulWidget {
  const TermsPdfScreen({super.key});

  @override
  State<TermsPdfScreen> createState() => _TermsPdfScreenState();
}

class _TermsPdfScreenState extends State<TermsPdfScreen> {
  bool _accepted = false;

  void _confirmTerms() {
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please read and accept the Terms & Conditions first.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset(
              'assets/terms/terms_and_conditions.pdf',
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, -2),
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: _accepted,
                  onChanged: (value) {
                    setState(() {
                      _accepted = value ?? false;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'I have read and agree to the Farmora Terms & Conditions.',
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _accepted ? _confirmTerms : null,
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}