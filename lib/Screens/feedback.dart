import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Feedback'),
      ),
      body: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController feedbackController = TextEditingController();

  void submitFeedback() {
    // TODO: Implement the logic to submit the feedback to your backend or store it locally.
    String feedback = feedbackController.text;
    print('Feedback submitted: $feedback');

    // Optionally, you can show a confirmation dialog or navigate to a thank-you page.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: feedbackController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'Enter your feedback',
              hintText: 'Tell us what you think...',
              labelStyle: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            maxLines: 10, // Allow multiline feedback
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: submitFeedback,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackPage(),
  ));
}
