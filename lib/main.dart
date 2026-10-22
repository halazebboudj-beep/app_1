import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

const purple = Color(0xFF4B2A8F);
const lilac = Color(0xFFE9E3F3);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Courgette'),
        home: const WelcomePage(),
      );
}

class Background extends StatelessWidget {
  final Widget child;
  final String top;
  final String bottom;
  final bool bottomRight;
  final bool showBack; 
  final double topW, bottomW;
  const Background({
    required this.child,
    required this.top,
    required this.bottom,
    this.bottomRight = false,
    this.showBack = false, 
    this.topW = 0.3,
    this.bottomW = 0.25,
    super.key
  });
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            child: Image.asset(top, width: size.width * topW)),
        Positioned(
            bottom: 0,
            left: bottomRight ? null : 0,
            right: bottomRight ? 0 : null,
            child: Image.asset(bottom, width: size.width * bottomW)),
        SafeArea(child: child),
        
        if (showBack)
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: purple),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
      ]),
    );
  }
}

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool filled;
  const Btn(this.text, this.onTap, {this.filled = true, super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: filled ? purple : lilac,
            foregroundColor: filled ? Colors.white : Colors.black87,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          onPressed: onTap,
          child: Text(text),
        ),
      );
}


class Field extends StatefulWidget {
  
  final String hint;
  final IconData icon;
  final bool pass;
  const Field(this.hint, this.icon, {this.pass = false, super.key});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          obscureText: widget.pass && hidden,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(widget.icon, color: purple),
            suffixIcon: widget.pass
                ? IconButton(
                    icon: Icon(
                      hidden ? Icons.visibility : Icons.visibility_off,
                      color: purple,
                    ),
                    onPressed: () => setState(() => hidden = !hidden),
                  )
                : null,
            filled: true,
            fillColor: lilac,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
}



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: Background(
        top: 'assets/images/main_top.png',
        bottom: 'assets/images/main_bottom.png',
        topW: 0.3,
        bottomW: 0.25,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('WELCOME TO EDU',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.04),
                SvgPicture.asset('assets/icons/chat.svg',
                    height: size.height * 0.4),SizedBox(height: size.height * 0.05),
                Btn(
                    'LOGIN',
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AuthPage(login: true)))),
                const SizedBox(height: 12),
                Btn(
                    'SIGNUP',
                    filled: false,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AuthPage(login: false)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  final bool login;
  const AuthPage({required this.login, super.key});

  Widget social(String name) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: lilac),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/icons/$name.svg',
            height: 20, width: 20),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        top: 'assets/images/signup_top.png',
        bottom: login
            ? 'assets/images/login_bottom.png'
            : 'assets/images/main_bottom.png',
        bottomRight: login,
        topW: 0.35,
        bottomW: login ? 0.4 : 0.25,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(login ? 'LOGIN' : 'SIGNUP',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                    login ? 'assets/icons/login.svg' : 'assets/icons/signup.svg',
                    height: size.height * 0.32),
                SizedBox(height: size.height * 0.03),
                const Field('hala@mail.com', Icons.person),
                const Field('Password', Icons.lock, pass: true),
                Btn(login ? 'LOGIN' : 'SIGNUP', () {}),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AuthPage(login: !login))),
                  child: Text(
                    login
                        ? "Don't have an Account ? Sign Up"
                        : 'Already have an Account ? Sign In',
                    style: const TextStyle(fontSize: 12, color: purple),
                  ),
                ),
                if (!login) ...[
                  const SizedBox(height: 14),
                  const Text('OR', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 14),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    social('facebook'),
                    social('twitter'),
                    social('google-plus'),
                  ]),
                ],
              ],
            ),
          ),
        ),
      ),
floatingActionButton: FloatingActionButton(onPressed: (){
   Navigator.pop(
                  context
                );
},
child: Icon(Icons.home),
),
 );
  }
}