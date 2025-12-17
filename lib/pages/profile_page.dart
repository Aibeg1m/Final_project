import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isMale = true;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = "Your name";
    _phoneController.text = "+7";
  }

  Future<void> _changePassword() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF163B63),
        title: const Text(
          "Change password",
          style: TextStyle(color: Color(0xFFE6EAF0)),
        ),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(hintText: "New password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFE6EAF0)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE6EAF0)),
            onPressed: () async {
              try {
                await user?.updatePassword(controller.text);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password updated")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Re-login required")),
                );
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Color(0xFF163B63)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.white,
      child: Icon(
        _isMale ? Icons.man : Icons.woman,
        size: 70,
        color: const Color(0xFF163B63),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF7B8CA3), fontSize: 13),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Color(0xFFE6EAF0)),
        ),
        backgroundColor: const Color(0xFF163B63),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _editMode = !_editMode);
            },
            child: Text(
              _editMode ? "Save" : "Edit",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _avatar(),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("Male"),
                        selected: _isMale,
                        onSelected: (_) => setState(() => _isMale = true),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Female"),
                        selected: !_isMale,
                        onSelected: (_) => setState(() => _isMale = false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _input("Name", _nameController, enabled: _editMode),
                  const SizedBox(height: 15),

                  _input("Phone", _phoneController, enabled: _editMode),
                  const SizedBox(height: 15),

                  _input(
                    "Email",
                    TextEditingController(text: user?.email ?? "No email"),
                    enabled: false,
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Change password",
                        style: TextStyle(color: Color(0xFF0E2A47)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Color(0xFFE6EAF0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
