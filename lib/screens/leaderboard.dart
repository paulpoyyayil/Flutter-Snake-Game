import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LEADERBOARD",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade200,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('high_scores')
            .orderBy('score', descending: true)
            .limit(10)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var player = snapshot.data!.docs[index];
              String name = player['name'];
              String score = player['score'].toString();

              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${index + 1}    ',
                      style: GoogleFonts.rubikGlitch(
                        fontSize: 20,
                        color: Colors.green.shade200,
                      ),
                    ),
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ),
                  ],
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.rubikGlitch(
                          fontSize: 20,
                          color: Colors.green.shade200,
                        ),
                      ),
                    ),
                    Text(
                      score,
                      style: GoogleFonts.rubikGlitch(
                        fontSize: 20,
                        color: Colors.green.shade200,
                      ),
                    ),
                  ],
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              );
            },
          );
        },
      ),
    );
  }
}
