import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cubism/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<Map<String, dynamic>> _failures = [];

  @override
  void initState() {
    super.initState();
    _loadArchive();
  }

  Future<void> _loadArchive() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList('archive_failures') ?? [];
    
    setState(() {
      _failures = savedList.map((str) => jsonDecode(str) as Map<String, dynamic>).toList();
      _failures = _failures.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.oledBlack,
      appBar: AppBar(
        title: Text(l10n.archive, style: Theme.of(context).textTheme.displayMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.clinicalWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _failures.isEmpty
          ? Center(
              child: Text(
                "NO FAILURES YET.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _failures.length,
              itemBuilder: (context, index) {
                final failure = _failures[index];
                final time = DateTime.parse(failure['time']);
                final formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
                final imagePath = failure['imagePath'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imagePath != null && File(imagePath).existsSync())
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(color: AppTheme.oledBlack.withValues(alpha: 0.5)),
                              Center(
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppTheme.murderRed, width: 6),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      "[ STATUS: VANDALIZED ]",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppTheme.murderRed,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                        backgroundColor: AppTheme.oledBlack.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      Container(
                        color: AppTheme.oledBlack,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CRIME: İradesizlik. Saat $formattedTime'de odaklanma terk edildi.",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.clinicalWhite,
                                fontFamily: 'IBMPlexMono',
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (failure.containsKey('elapsedSeconds') && failure.containsKey('targetSeconds')) ...[
                              Text(
                                "DAYANMA SÜRESİ: ${(failure['elapsedSeconds'] ~/ 60)} Dakika ${(failure['elapsedSeconds'] % 60).toInt()} Saniye.",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.clinicalWhite,
                                  fontFamily: 'IBMPlexMono',
                                ),
                              ),
                              Text(
                                "EKSİK KALAN: Sadece ${(failure['targetSeconds'] - failure['elapsedSeconds']).toInt()} saniye.",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.murderRed,
                                  fontFamily: 'IBMPlexMono',
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      Container(height: 2, color: AppTheme.clinicalWhite),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
