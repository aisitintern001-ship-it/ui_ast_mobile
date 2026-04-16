import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final String mode; // 'Time In' or 'Time Out'

  const FaceRecognitionScreen({super.key, required this.mode});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen>
    with WidgetsBindingObserver {
  int _confirmCount = 0;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCameraError = false;
  String? _cameraErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _isCameraError = true;
          _cameraErrorMessage = 'No cameras available on this device';
        });
        return;
      }

      // Try to find front camera first for face recognition
      CameraDescription? frontCamera;
      for (final camera in _cameras!) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }

      // Fall back to first camera if no front camera
      final selectedCamera = frontCamera ?? _cameras!.first;

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isCameraError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraError = true;
          _cameraErrorMessage = 'Failed to initialize camera: ${e.toString()}';
        });
      }
    }
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFCA5A5), width: 1), // Light red border
          ),
          backgroundColor: const Color(0xFFFEF2F2), // Light red background wash
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red X Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.x,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  '${widget.mode} Failed',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  'Face verification could not be completed.\nPlease try again.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                
                // Try Again Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog to try again
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: Text(
                      'Try Again',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dismiss Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(false); // Exit screen entirely
                  },
                  child: Text(
                    'Dismiss',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onConfirm() {
    if (_confirmCount == 0) {
      _confirmCount++;
      // Trigger the pop-up modal
      _showFailedDialog();
      
      // Kept the toast just in case, but you can remove it if the modal is enough
      AppToast.show(
        context,
        type: ToastType.error,
        title: 'Face verification failed. Please try again.',
        message: 'Please ensure your face is clearly visible and try again.',
      );
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCameraScreen(context);
  }

  Widget _buildCameraScreen(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        title: Text(
          'Face Recognition',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Camera preview
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera preview or placeholder
                if (_isCameraInitialized && _cameraController != null)
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(_cameraController!),
                  )
                else if (_isCameraError)
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _cameraErrorMessage ?? 'Camera not available',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _initializeCamera,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: headerColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initializing camera...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Face guide overlay
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(130),
                    border: Border.all(
                      color: _isCameraInitialized ? headerColor : Colors.white,
                      width: 3,
                    ),
                  ),
                ),

                // Corner guides
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: MediaQuery.of(context).size.width * 0.15,
                  child: _buildCornerGuide(headerColor, topLeft: true),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: _buildCornerGuide(headerColor, topRight: true),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.15,
                  child: _buildCornerGuide(headerColor, bottomLeft: true),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: _buildCornerGuide(headerColor, bottomRight: true),
                ),

                // Instructions overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Position your face within the circle',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${widget.mode} with face recognition',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.divider),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isCameraInitialized || _isCameraError
                            ? _onConfirm
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: headerColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerGuide(Color color,
      {bool topLeft = false,
      bool topRight = false,
      bool bottomLeft = false,
      bool bottomRight = false}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _CornerPainter(
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerPainter({
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}