import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reward_winner.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

// ─── Colour Tokens ────────────────────────────────────────────────────────────
const _gold = Color(0xFFB8860B);
const _goldLight = Color(0xFFD4A017);
const _goldXLight = Color(0xFFF5E6A3);
const _cream = Color(0xFFFFFDF4);
const _ink = Color(0xFF1A1A2E);
const _inkLight = Color(0xFF4A4A6A);

class CertificateScreen extends StatefulWidget {
  final RewardWinner winner;

  const CertificateScreen({super.key, required this.winner});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isDownloading = false;
  bool _isSharing = false;

  Future<void> _downloadCertificate() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      // 1. Capture the widget as an image
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2. Save to temporary directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'Certificate_${widget.winner.name.replaceAll(' ', '_')}_${widget.winner.year}.png';
      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (mounted) {
        _showSnack(context, 'Certificate downloaded successfully!');
        // 3. Open the file
        OpenFile.open(filePath);
      }
    } catch (e) {
      if (mounted) {
        _showSnack(context, 'Error downloading certificate: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _shareCertificate() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      // 1. Capture the widget as an image
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2. Save to temporary directory
      final directory = await getTemporaryDirectory();
      final String fileName = 'Share_Certificate_${widget.winner.name.replaceAll(' ', '_')}.png';
      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // 3. Share the file
      if (mounted) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final Rect? shareRect = box != null 
            ? box.localToGlobal(Offset.zero) & box.size 
            : null;

        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Check out my Digital Certificate from Gram Panchayat!',
          sharePositionOrigin: shareRect,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnack(context, 'Error sharing certificate: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Digital Certificate',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _AppBarAction(
            icon: _isDownloading ? Icons.hourglass_empty_rounded : Icons.download_rounded,
            tooltip: 'Download',
            onTap: _downloadCertificate,
          ),
          _AppBarAction(
            icon: _isSharing ? Icons.hourglass_empty_rounded : Icons.share_rounded,
            tooltip: 'Share',
            onTap: _shareCertificate,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Certificate width: at most 520 logical px, never wider than screen
                final certWidth = math.min(constraints.maxWidth, 520.0);
                // A4 Portrait ratio ≈ 1 : √2  →  height = width * 1.414
                final certHeight = certWidth * 1.414;

                return RepaintBoundary(
                  key: _globalKey,
                  child: SizedBox(
                    width: certWidth,
                    height: certHeight,
                    child: _CertificateCard(winner: widget.winner),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext ctx, String msg) =>
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _gold,
        ),
      );
}

// ─── Certificate Card ─────────────────────────────────────────────────────────

class _CertificateCard extends StatelessWidget {
  final RewardWinner winner;
  const _CertificateCard({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gold, width: 10),
        boxShadow: [
          BoxShadow(
            color: _gold.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Watermark background pattern ──────────────────────────────────
          Positioned.fill(child: _WatermarkPattern()),

          // ── Thin inner border ─────────────────────────────────────────────
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _gold.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ── Corner ornaments ──────────────────────────────────────────────
          const Positioned(top: 18, left: 18, child: _Corner()),
          const Positioned(
            top: 18,
            right: 18,
            child: _Corner(flipH: true),
          ),
          const Positioned(
            bottom: 18,
            left: 18,
            child: _Corner(flipV: true),
          ),
          const Positioned(
            bottom: 18,
            right: 18,
            child: _Corner(flipH: true, flipV: true),
          ),

          // ── Main content ──────────────────────────────────────────────────
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  // Fixed reference width so FittedBox has a concrete size to scale from
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Header(),
                      const SizedBox(height: 10),
                      _GoldDivider(),
                      const SizedBox(height: 14),
                      _RecipientSection(winner: winner),
                      const SizedBox(height: 10),
                      _GoldDivider(),
                      const SizedBox(height: 12),
                      _AwardBody(winner: winner),
                      const SizedBox(height: 20),
                      _GoldDivider(),
                      const SizedBox(height: 14),
                      _SignatureRow(),
                      const SizedBox(height: 8),
                      _FooterStamp(winner: winner),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seal
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [_goldLight, _gold],
              center: Alignment(-0.3, -0.3),
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _gold.withOpacity(0.5),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
        const SizedBox(height: 12),

        // Organisation name
        Text(
          'GRAM PANCHAYAT',
          style: GoogleFonts.cinzel(
            fontSize: 11,
            letterSpacing: 5,
            color: _inkLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        // Title
        Text(
          'CERTIFICATE',
          style: GoogleFonts.cinzel(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: _gold,
            letterSpacing: 6,
          ),
        ),
        Text(
          'OF EXCELLENCE',
          style: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _gold.withOpacity(0.75),
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

// ─── Recipient Section ────────────────────────────────────────────────────────

class _RecipientSection extends StatelessWidget {
  final RewardWinner winner;
  const _RecipientSection({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'This certificate is proudly presented to',
          style: GoogleFonts.playfairDisplay(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: _inkLight,
          ),
        ),
        const SizedBox(height: 10),

        // Avatar + Name row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Initial avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [winner.categoryColor, winner.categoryColor.withOpacity(0.6)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: _gold, width: 2),
              ),
              child: Center(
                child: Text(
                  winner.name.isNotEmpty ? winner.name[0].toUpperCase() : '?',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name
            Flexible(
              child: Text(
                winner.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _ink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Village tag
        Text(
          winner.village,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: _inkLight,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─── Award Body ───────────────────────────────────────────────────────────────

class _AwardBody extends StatelessWidget {
  final RewardWinner winner;
  const _AwardBody({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: winner.categoryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: winner.categoryColor.withOpacity(0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(winner.categoryIcon, size: 15, color: winner.categoryColor),
              const SizedBox(width: 6),
              Text(
                winner.categoryName,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: winner.categoryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Recognition body text
        Text(
          'In recognition of outstanding contribution and being awarded the honour of\n'
          '"${winner.categoryName}" for the year ${winner.year}.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 11.5,
            color: _inkLight,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 10),

        // Achievement highlight
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _goldXLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _gold.withOpacity(0.4)),
          ),
          child: Text(
            '"${winner.achievement}"',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: _ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Signature Row ────────────────────────────────────────────────────────────

class _SignatureRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Signature(title: 'Village Sarpanch'),
        _Signature(title: 'District Officer'),
        _Signature(title: 'Gram Sachiv'),
      ],
    );
  }
}

class _Signature extends StatelessWidget {
  final String title;
  const _Signature({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stylised signature squiggle
        SizedBox(
          width: 72,
          child: CustomPaint(painter: _SignaturePainter()),
        ),
        const SizedBox(height: 4),
        Container(height: 1, width: 72, color: _gold.withOpacity(0.7)),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            color: _ink,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

// ─── Footer Stamp ─────────────────────────────────────────────────────────────

class _FooterStamp extends StatelessWidget {
  final RewardWinner winner;
  const _FooterStamp({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ID: ${winner.id.length > 8 ? winner.id.substring(0, 8).toUpperCase() : winner.id.toUpperCase()}',
          style: GoogleFonts.robotoMono(
            fontSize: 8,
            color: _inkLight.withOpacity(0.6),
          ),
        ),
        Text(
          'Issued: ${winner.dateAwarded.day.toString().padLeft(2, '0')} '
          '${_monthName(winner.dateAwarded.month)} ${winner.dateAwarded.year}',
          style: GoogleFonts.robotoMono(
            fontSize: 8,
            color: _inkLight.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  static String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}

// ─── Gold Divider ─────────────────────────────────────────────────────────────

class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: _gold, thickness: 0.8)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.auto_awesome,
              size: 10, color: _gold.withOpacity(0.8)),
        ),
        const Expanded(child: Divider(color: _gold, thickness: 0.8)),
      ],
    );
  }
}

// ─── Watermark Pattern ────────────────────────────────────────────────────────

class _WatermarkPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WatermarkPainter());
  }
}

class _WatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gold.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    // Draw subtle circular pattern grid
    const spacing = 48.0;
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 14, paint);
      }
    }

    // Central large watermark ring
    final ringPaint = Paint()
      ..color = _gold.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.36,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Corner Ornament ──────────────────────────────────────────────────────────

class _Corner extends StatelessWidget {
  final bool flipH;
  final bool flipV;
  const _Corner({this.flipH = false, this.flipV = false});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: flipH ? -1 : 1,
      scaleY: flipV ? -1 : 1,
      child: CustomPaint(
        size: const Size(28, 28),
        painter: _CornerPainter(),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gold
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height);
    canvas.drawPath(path, paint);

    // Inner decorative tick
    final tick = Paint()
      ..color = _gold
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(6, 0),
      Offset(6, 6),
      tick,
    );
    canvas.drawLine(
      Offset(0, 6),
      Offset(6, 6),
      tick,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Signature Painter ────────────────────────────────────────────────────────

class _SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _ink.withOpacity(0.55)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(4, size.height * 0.6)
      ..cubicTo(
        size.width * 0.2, size.height * 0.1,
        size.width * 0.35, size.height,
        size.width * 0.5, size.height * 0.4,
      )
      ..cubicTo(
        size.width * 0.65, 0,
        size.width * 0.8, size.height * 0.9,
        size.width - 4, size.height * 0.5,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── AppBar Action Button ─────────────────────────────────────────────────────

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _AppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
      color: Colors.white,
    );
  }
}
