
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'AuthenticationScreeen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background to transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),

                // Wrap your widgets with AnimationLimiter to apply staggered animations
                AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 700),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        _buildWelcomeText(),
                        SizedBox(height: 20),
                        _buildSubtitleText(),
                      ],
                    ),
                  ),
                ),

                // Add a button for further actions
                SizedBox(height: 50),
                _buildGetStartedButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset('Assets/logo.png', width: 150, height: 150);
  }

  Widget _buildWelcomeText() {
    return Text(
      'Welcome to HuruChat!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return Text(
      'Connecting people, one chat at a time.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the authentication screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthenticationScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.white),
        ),
      ),
      child: Text(
        'Get Started',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
