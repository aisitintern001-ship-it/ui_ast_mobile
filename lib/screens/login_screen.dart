import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/text_input.dart';
import '../widgets/animations/animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController(
    text: 'mac.llanes@company.com',
  );
  final _passwordController = TextEditingController(text: 'password123');
  final _orgIdController = TextEditingController(
    text: '3',
  );
  bool _obscurePassword = true;
  
  late AnimationController _logoController;
  late AnimationController _cardController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardOpacity;

  @override
  void initState() {
    super.initState();
    
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController, 
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    // Card animation
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    
    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _logoController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    HapticFeedback.mediumImpact();
    final state = context.read<AppState>();
    final success = await state.login(
      _emailController.text,
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Animated logo
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/AST2.svg',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AUSTRALIA SOFTWARE TECHNOLOGY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 106, 139),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Animated welcome card
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardOpacity,
                  child: Container(
                    width: size.width > 480 ? 400 : size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top section with logo area
                    Container(
                      padding: const EdgeInsets.only(
                        left: 32,
                        top: 32,
                        right: 32,
                        bottom: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo placeholder
                          const SizedBox(height: 24),
                          Text(
                            'Login your Account',
                            style: GoogleFonts.inter(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 95, 140, 189),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Please enter your login details',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email field
                          const SizedBox(height: 8),
                          AppTextInput(
                            controller: _orgIdController,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            hintText: 'Enter your Organization ID',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                            prefixIcon: const Icon(
                              Icons.apartment_outlined,
                              size: 18,
                              color: Color.fromARGB(255, 134, 163, 215),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.headerOrange,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),

                          const SizedBox(height: 20),
                          AppTextInput(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            hintText: 'Enter your email',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              size: 18,
                              color: Color.fromARGB(255, 134, 163, 215),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.headerOrange,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          const SizedBox(height: 8),
                          AppTextInput(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            hintText: 'Enter your password',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 18,
                              color: Color.fromARGB(255, 134, 163, 215),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                                color: const Color.fromARGB(255, 134, 163, 215),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.headerOrange,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          const SizedBox(height: 12),

                          const SizedBox(height: 24),

                          // Animated Sign in button
                          TapBounceButton(
                            onTap: state.isLoading ? null : _handleLogin,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 130, 110, 230),
                                    Color.fromARGB(255, 105, 85, 200),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 117, 97, 219)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: state.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        'LOGIN',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 170),

                          // Contact support
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Do you need help? ',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Put your action here (e.g., navigate to support)
                                    if (kDebugMode) {
                                      print('Click Here tapped!');
                                    }
                                  },
                                  child: Text(
                                    'Click Here',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color.fromARGB(
                                        255,
                                        120,
                                        148,
                                        238,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text(
                              '1.0.0',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
