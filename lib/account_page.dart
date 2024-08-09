import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page

class AccountPage extends StatelessWidget {
  void _logout(BuildContext context) {
    // Perform logout operations here (e.g., clear user session, tokens, etc.)

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 20),
            // User details
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User Name'),
              subtitle: Text('11740@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logout(context), // Add onTap to handle logout
            ),
          ],
        ),
      ),
    );
  }
}