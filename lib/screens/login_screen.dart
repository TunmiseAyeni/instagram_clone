import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/resources/authentication.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isObscure = true;
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  void tooglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void logIn() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().logInUser(
        email: emailController.text, password: passWordController.text);
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Logged in successfully');
      //navigate to the next Screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        );
      }));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to prevent the screen from resizing when the keyboard is opened
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //to create space between the top of the screen and the first widget
              Expanded(child: Container()),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: Colors.white,
                height: 65,
              ),
              const SizedBox(
                height: 64,
              ),
              TextInputField(
                text: 'Email',
                icon: const Icon(Icons.email),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextInputField(
                  text: 'Password',
                  icon: const Icon(Icons.lock),
                  controller: passWordController,
                  keyboardType: TextInputType.text,
                  iconButton: IconButton(
                      onPressed: tooglePasswordVisibility,
                      icon: Icon(_isObscure
                          ? Icons.visibility_off
                          : Icons.visibility)),
                  obscureText: _isObscure),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  onPressed: logIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              //to create space between the bottom of the screen and the last widget
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
