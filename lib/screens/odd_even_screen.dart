import 'package:flutter/material.dart';

class OddEvenScreen extends StatefulWidget {
	const OddEvenScreen({super.key});

	@override
	State<OddEvenScreen> createState() => _OddEvenScreenState();
}

class _OddEvenScreenState extends State<OddEvenScreen> {
	final _formKey = GlobalKey<FormState>();
	final _numberController = TextEditingController();
	String? _result;
	int? _checkedNumber;

	@override
	void dispose() {
		_numberController.dispose();
		super.dispose();
	}

	void _checkNumber() {
		if (!_formKey.currentState!.validate()) {
			setState(() {
				_result = null;
				_checkedNumber = null;
			});
			return;
		}

		final number = int.parse(_numberController.text.trim());
		setState(() {
			_checkedNumber = number;
			_result = number.isEven ? 'Genap' : 'Ganjil';
		});
	}

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;

		return Scaffold(
			appBar: AppBar(
				title: const Text('Cek Ganjil / Genap'),
				centerTitle: true,
				backgroundColor: colorScheme.inversePrimary,
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Form(
						key: _formKey,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								Icon(
									Icons.pin_rounded,
									size: 72,
									color: colorScheme.primary,
								),
								const SizedBox(height: 16),
								Text(
									'Masukkan sebuah angka',
									textAlign: TextAlign.center,
									style: Theme.of(context).textTheme.headlineSmall?.copyWith(
												fontWeight: FontWeight.bold,
											),
								),
								const SizedBox(height: 8),
								Text(
									'Aplikasi akan menentukan apakah angka tersebut genap atau ganjil.',
									textAlign: TextAlign.center,
									style: TextStyle(color: colorScheme.onSurfaceVariant),
								),
								const SizedBox(height: 32),
								TextFormField(
									controller: _numberController,
									keyboardType: TextInputType.number,
									textInputAction: TextInputAction.done,
									decoration: const InputDecoration(
										labelText: 'Angka',
										hintText: 'Contoh: 24',
										prefixIcon: Icon(Icons.numbers_rounded),
										border: OutlineInputBorder(),
									),
									validator: (value) {
										final text = value?.trim() ?? '';
										if (text.isEmpty) {
											return 'Angka wajib diisi';
										}
										if (int.tryParse(text) == null) {
											return 'Masukkan bilangan bulat yang valid';
										}
										return null;
									},
									onFieldSubmitted: (_) => _checkNumber(),
								),
								const SizedBox(height: 16),
								FilledButton.icon(
									onPressed: _checkNumber,
									icon: const Icon(Icons.search_rounded),
									label: const Text('Cek Angka'),
								),
								if (_result != null) ...[
									const SizedBox(height: 28),
									Card(
										color: colorScheme.primaryContainer,
										child: Padding(
											padding: const EdgeInsets.all(24),
											child: Column(
												children: [
													Icon(
														_result == 'Genap'
																? Icons.circle_outlined
																: Icons.change_history,
														size: 48,
														color: colorScheme.primary,
													),
													const SizedBox(height: 12),
													Text(
														'$_checkedNumber adalah bilangan $_result',
														textAlign: TextAlign.center,
														style: Theme.of(context)
																.textTheme
																.titleLarge
																?.copyWith(fontWeight: FontWeight.bold),
													),
												],
											),
										),
									),
								],
							],
						),
					),
				),
			),
		);
	}
}
