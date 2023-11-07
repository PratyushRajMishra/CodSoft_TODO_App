import 'package:flutter/material.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('About'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Image.asset(
                  "assests/logo.png",
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Listify',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.purple,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.0),
                ),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                      color: Colors.black54, letterSpacing: 0.5, fontSize: 15),
                ),
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    "'Listify' is a versatile to-do list app designed to streamline task management and increase productivity. "
                        "With its intuitive and user-friendly interface, Listify allows users to effortlessly create, organize, "
                        "and prioritize their tasks and to-do lists. It offers features like due dates, reminders, and task categorization, "
                        "enabling users to stay on top of their commitments. Listify also syncs across devices, ensuring access to your tasks "
                        "wherever you go. Whether you're managing daily chores, work projects, or personal goals, Listify simplifies "
                        "the process and helps you stay organized. With Listify, you can enhance your task management experience "
                        "and take control of your daily activities, making it an essential tool for anyone seeking an efficient and effective to-do list app.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                Divider(),
                SizedBox(
                  height: 25,
                ),
                const Text(
                  'Developer: Pratyush Mishra',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
                const Text(
                  'pratyushrajmishra70@gmail.com',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  '+919454969946',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'Gorakhpur, Uttar Pradesh, India',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'Pincode- 273001',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}