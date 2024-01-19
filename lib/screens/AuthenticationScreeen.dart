import 'package:HuruChat/screens/SettingsScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackgroundImage(),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
              child: _buildGlassContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabBar(),
                    SizedBox(height: 20),
                    _buildTabBarView(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'Assets/Friends-Having-Fun.png',
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return GlassContainer.frostedGlass(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: 'Login'),
        Tab(text: 'Register'),
      ],
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3.0,
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildLoginContent(),
            _buildRegisterContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginContent() {
    return Column(
      children: [
        _buildAnimatedField(
          controller: _usernameController,
          labelText: 'Username',
          icon: Icons.person,
        ),
        SizedBox(height: 24),
        _buildAnimatedField(
          controller: _passwordController,
          labelText: 'Password',
          icon: Icons.lock,
          obscureText: true,
        ),
        SizedBox(height: 24),
        _buildAnimatedButton(
          onPressed: _handleLogin,
          label: 'Login',
          color: Colors.blue,
        ),
        SizedBox(height: 24),
        _buildSocialButtons(),
      ],
    );
  }

  Widget _buildRegisterContent() {
    return Column(
      children: [
        _buildAnimatedField(
          controller: _emailController,
          labelText: 'Email*',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),
        _buildAnimatedField(
          controller: _usernameController,
          labelText: 'Username*',
          icon: Icons.person,
        ),
        SizedBox(height: 16),
        _buildAnimatedField(
          controller: _passwordController,
          labelText: 'Password*',
          icon: Icons.lock,
          obscureText: true,
        ),
        SizedBox(height: 16),
        _buildAnimatedField(
          controller: _confirmPasswordController,
          labelText: 'Confirm Password*',
          icon: Icons.lock,
          obscureText: true,
        ),
        SizedBox(height: 16),
        _buildAnimatedPhoneNumberInput(),
        SizedBox(height: 16),
        _buildAnimatedButton(
          onPressed: _handleRegistration,
          label: 'Register',
          color: Colors.green,
        ),
        SizedBox(height: 16),
        _buildSocialButtons(),
      ],
    );
  }

  List<String> _getInvalidUsernameMessages(String username) {
    List<String> errors = [];

    // Check if the username begins or ends with non-alphanumeric characters except periods (.).
    if (!RegExp(r'^[a-zA-Z0-9.].*[a-zA-Z0-9.]$').hasMatch(username)) {
      errors.add(
          'Username must begin and end with letters, numbers, or periods.');
    }

    // Check if the username contains only allowed characters (letters, numbers, and periods).
    if (!RegExp(r'^[a-zA-Z0-9.]+$').hasMatch(username)) {
      errors.add('Username can only contain letters, numbers, and periods.');
    }

    // Check if the username contains more than one period (.) consecutively.
    if (RegExp(r'\.{2,}').hasMatch(username)) {
      errors.add('Username cannot contain more than one period consecutively.');
    }

    // Add more rules as needed.

    return errors;
  }

  void _handleRegistration() {
    // Validate email
    if (!EmailValidator.validate(_emailController.text)) {
      _showErrorSnackBar('Invalid email address');
      return;
    }

    // Validate username
    List<String> usernameErrors =
        _getInvalidUsernameMessages(_usernameController.text);
    if (usernameErrors.isNotEmpty) {
      String errorMessage =
          'Invalid username. Please check the following rules:\n';
      errorMessage += usernameErrors.join('\n');
      _showErrorSnackBar(errorMessage);
      return;
    }

    // Validate password
    if (!_isPasswordValid(_passwordController.text)) {
      _showErrorSnackBar(
          'Password must be at least six characters with at least 1 uppercase letter, 1 lowercase letter, and 1 symbol');
      return;
    }

    // Other registration logic goes here

    Map<String, String> userData = {
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'phoneNumber': _phoneNumberController.text,
    };
    print(userData);
    // Navigate to the authentication screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  bool _isPasswordValid(String password) {
    // Password must be at least six characters with at least 1 uppercase letter,
    // 1 lowercase letter, and 1 symbol
    RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$');

    return passwordRegex.hasMatch(password);
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      constraints: BoxConstraints(minWidth: 100.0),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: labelText,
            icon: Icon(icon, color: Colors.black),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPhoneNumberInput() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      constraints: BoxConstraints(minWidth: 100.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: IntlPhoneField(
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      color: color,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          onPressed: _handleGoogleLogin,
          icon: FaIcon(FontAwesomeIcons.google, size: 18, color: Colors.white),
          label: Text('Google',
              style: TextStyle(fontSize: 12, color: Colors.white)),
          color: Colors.red,
        ),
        _buildSocialButton(
          onPressed: _handleAppleLogin,
          icon: FaIcon(FontAwesomeIcons.apple, size: 18, color: Colors.white),
          label: Text('Apple',
              style: TextStyle(fontSize: 12, color: Colors.white)),
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Widget icon,
    required Widget label,
    required Color color,
  }) {
    return GlassContainer.frostedGlass(
      height: 50,
      width: 120,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 8),
            label,
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    // Handle login
    // Navigate to the authentication screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  void _handleGoogleLogin() {
    // Handle Google login
  }

  void _handleAppleLogin() {
    // Handle Apple login
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
