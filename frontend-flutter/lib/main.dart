

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
	bool isLoadingHello = false;
	bool isLoadingGreet = false;
	final TextEditingController _controller = TextEditingController();

	Future<void> fetchHello({String? name}) async {
		setState(() { isLoadingHello = true; });
		try {
			final uri = Uri.parse('http://localhost:5000/api/hello${name != null && name.isNotEmpty ? '?name=${Uri.encodeComponent(name)}' : ''}');
			final response = await http.get(uri);
			if (response.statusCode == 200) {
				final data = json.decode(response.body);
				setState(() {
					helloMessage = data['message'] ?? '';
				});
			} else {
				setState(() { helloMessage = 'Erreur serveur'; });
			}
		} catch (e) {
			setState(() { helloMessage = 'Erreur réseau'; });
		} finally {
			setState(() { isLoadingHello = false; });
		}
	}

	Future<void> sendGreet() async {
		setState(() { isLoadingGreet = true; greetMessage = ''; });
		try {
			final response = await http.post(
				Uri.parse('http://localhost:5000/api/greet'),
				headers: {'Content-Type': 'application/json'},
				body: json.encode({'name': _controller.text}),
			);
			final data = json.decode(response.body);
			if (response.statusCode == 200 && data['success'] == true) {
				setState(() { greetMessage = data['message'] ?? ''; });
				// Optionnel : rafraîchir hello avec le nom
				fetchHello(name: _controller.text);
			} else {
				setState(() { greetMessage = data['message'] ?? 'Erreur'; });
			}
		} catch (e) {
			setState(() { greetMessage = 'Erreur réseau'; });
		} finally {
			setState(() { isLoadingGreet = false; });
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
							isLoadingHello
									? CircularProgressIndicator()
									: Text(helloMessage, style: TextStyle(fontSize: 20)),
							SizedBox(height: 24),
							TextField(
								controller: _controller,
								decoration: InputDecoration(labelText: 'Votre nom'),
								onSubmitted: (_) => sendGreet(),
							),
							SizedBox(height: 8),
							ElevatedButton(
								onPressed: isLoadingGreet ? null : sendGreet,
								child: isLoadingGreet ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Envoyer'),
							),
							SizedBox(height: 16),
							if (greetMessage.isNotEmpty)
								Text(greetMessage, style: TextStyle(fontSize: 18, color: Colors.blue)),
						],
					),
				),
			);
		}
}
