import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const SizedBox(height: 16),
              const Text("Last updated: 28/8/2024"),
              const SizedBox(height: 16),
              const Text(
                "Your privacy is important to us. It is callerXYZ's policy to respect your privacy regarding any information we may collect from you through our mobile application.",
              ),
              const SizedBox(height: 16),
              const Text(
                "Information We Collect:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we're collecting it and how it will be used.",
              ),
              const SizedBox(height: 8),
              const Text("We collect the following information:"),
              const SizedBox(height: 4),
              const Text("• Name"),
              const Text(
                  "• Google account details (email, profile picture, name)"),
              const Text("• Device hardware information"),
              const SizedBox(height: 16),
              const Text(
                "Data Usage:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("The collected data is used to:"),
              const SizedBox(height: 4),
              const Text("• Track your cold call progress"),
              const Text("• Provide updates about the app"),
              const SizedBox(height: 8),
              const Text(
                "No sensitive data is collected. We do not record any calls or audio.",
              ),
              const SizedBox(height: 16),
              const Text(
                "Third-Party Services:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                  "We use third-party services to help us manage the app:"),
              const SizedBox(height: 4),
              const Text("• Firebase: Used for authentication"),
              const Text("• Supabase: Used for data storage"),
              const SizedBox(height: 8),
              const Text(
                "These services may collect information about your device, and your cold calling performance data, which you input manually. All stored data is encrypted and is not shared with any third party for any purpose.",
              ),
              const SizedBox(height: 16),
              const Text(
                "Data Storage and Security:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your data is stored on Supabase servers and is encrypted to protect it from unauthorized access. You have full control over your data and can create, access, modify, or delete it at any time.",
              ),
              const SizedBox(height: 16),
              const Text(
                "User Rights:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("You have the right to:"),
              const SizedBox(height: 4),
              const Text("• Access your personal data"),
              const Text("• Correct errors in your personal data"),
              const Text("• Delete your personal data"),
              const SizedBox(height: 8),
              const Text(
                "To exercise these rights, please contact us at aadityajagdale.21@gmail.com.",
              ),
              const SizedBox(height: 16),
              const Text(
                "External Links:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("The app does not link to any external sites."),
              const SizedBox(height: 16),
              const Text(
                "Changes to This Privacy Policy:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We may update our Privacy Policy from time to time. We will notify you of any changes through the app or on our website.",
              ),
              const SizedBox(height: 16),
              const Text(
                "Contact Us:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "If you have any questions about this Privacy Policy, please contact us at aadityajagdale.21@gmail.com.",
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
