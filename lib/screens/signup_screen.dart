import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/authentication.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Uint8List? userImage;
  bool _isObscure = true;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final userNameController = TextEditingController();
  final bioController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    bioController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void tooglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void takePicture() async {
    final imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (selectedImage != null) {
      //converting the image to bytes
      final imageFile = await selectedImage.readAsBytes();
      setState(() {
        userImage = imageFile;
      });
    }
    return;
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().signUpUser(
        email: emailController.text,
        password: passWordController.text,
        username: userNameController.text,
        bio: bioController.text,
        profileImage: userImage!);
    if (res != 'success') {
      //show the error message as a snackbar
      showSnackBar(context, res);
    } else {
      //if it is successful, show a success snackbar
      showSnackBar(context, 'User created successfully');
      //navigate to the next screen and using pushReplacement to prevent the user from going back to the sign up screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        );
      }));
    }
    //set the loading to false to stop the loading indicator
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: Colors.white,
                  height: 65,
                ),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    userImage != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(userImage!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundColor: webBackgroundColor,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: blueColor,
                          ),
                          onPressed: takePicture,
                        ))
                  ],
                ),
                const SizedBox(height: 20),
                TextInputField(
                  text: 'Mobile Number or Email',
                  icon: const Icon(Icons.email),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),
                TextInputField(
                    text: 'Username',
                    controller: userNameController,
                    keyboardType: TextInputType.text),
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
                TextInputField(
                    text: 'Enter your Bio...',
                    controller: bioController,
                    keyboardType: TextInputType.text),
                const SizedBox(height: 20),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                    onPressed: signUp,
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
                          ))
                        : const Text('Sign up'),
                  ),
                ),
                // const SizedBox(
                //   height: 12,
                // ),
                //to create space between the bottom of the screen and the last widget
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          //unfocus the text field
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text(
                          'Log in',
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
      ),
    );
  }
}
