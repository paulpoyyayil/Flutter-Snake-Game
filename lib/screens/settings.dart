import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/constants.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SOUND',
                  style: GoogleFonts.rubikGlitch(
                    fontSize: context.responsive(22),
                    color: Colors.green.shade200,
                    letterSpacing: 3,
                    decorationThickness: 10,
                  ),
                ),
                CustomCheckBox(
                  value: hasSound,
                  checkedFillColor: Colors.green,
                  borderRadius: 8,
                  borderWidth: 1,
                  checkBoxSize: 22,
                  onChanged: (val) {
                    setState(() {
                      hasSound = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: context.responsive(34),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'VIBRATION',
                  style: GoogleFonts.rubikGlitch(
                    fontSize: context.responsive(22),
                    color: Colors.green.shade200,
                    letterSpacing: 3,
                    decorationThickness: 10,
                  ),
                ),
                CustomCheckBox(
                  value: hasVibration,
                  checkedFillColor: Colors.green,
                  borderRadius: 8,
                  borderWidth: 1,
                  checkBoxSize: 22,
                  onChanged: (val) {
                    setState(() {
                      hasVibration = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
