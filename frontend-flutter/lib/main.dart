
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Stagiaire Test',
			home: HomePage(),
		);
	}
}

class HomePage extends StatefulWidget {
	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	String helloMessage = '';
	String greetMessage = '';
	final TextEditingController _controller = TextEditingController();

	Future<void> fetchHello() async {
		final response = await http.get(Uri.parse('http://localhost:5000/hello'));
		if (response.statusCode == 200) {
			setState(() {
				helloMessage = json.decode(response.body)['message'];
			});
		}
	}

	Future<void> sendGreet() async {
		final response = await http.post(
			Uri.parse('http://localhost:5000/greet'),
			headers: {'Content-Type': 'application/json'},
			body: json.encode({'name': _controller.text}),
		);
		if (response.statusCode == 200) {
			setState(() {
				greetMessage = json.decode(response.body)['message'];
			});
		} else {
			setState(() {
				greetMessage = json.decode(response.body)['error'] ?? 'Erreur';
			});
		}
	}

	@override
	void initState() {
		super.initState();
		fetchHello();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Stagiaire Test')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text(helloMessage, style: TextStyle(fontSize: 20)),
						SizedBox(height: 24),
						TextField(
							controller: _controller,
							decoration: InputDecoration(labelText: 'Votre nom'),
						),
						SizedBox(height: 8),
						ElevatedButton(
							onPressed: sendGreet,
							child: Text('Envoyer'),
						),
						SizedBox(height: 16),
						Text(greetMessage, style: TextStyle(fontSize: 18, color: Colors.blue)),
					],
				),
			),
		);
	}
}
