import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_forwarder/models/app_parameters.dart';
import 'package:sms_forwarder/pages/edit_parameters_page.dart';

class HomePageBuilder extends StatelessWidget {
  const HomePageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOpened = context.watch<bool>();
    if (isOpened) return const HomePage();

    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parameters = context.watch<AppParameters?>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Forwarder'),
      ),
      body: parameters == null
          ? const Center(
              child: Text('No Parameters are set.'),
            )
          : ParametersList(
              parameters: parameters,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onPressed(context, parameters),
        label: const Text('Edit Parameters'),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  void _onPressed(
    BuildContext context,
    AppParameters? parameters,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditParametersPage(
          parameters: parameters,
        ),
      ),
    );
  }
}

class ParametersList extends StatelessWidget {
  const ParametersList({
    Key? key,
    required this.parameters,
  }) : super(key: key);
  final AppParameters parameters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          /// smsUrl, ok, fail, api, enabled
          TextFormField(
            key: Key(parameters.smsUrl),
            readOnly: true,
            decoration: const InputDecoration(
              label: Text('SMS URL'),
            ),
            initialValue: parameters.smsUrl,
          ),
          TextFormField(
            key: Key(parameters.healthCheckUrlOk),
            readOnly: true,
            decoration: const InputDecoration(
              label: Text('Health Okay URL'),
            ),
            initialValue: parameters.healthCheckUrlOk,
          ),
          TextFormField(
            key: Key(parameters.healthCheckUrlFail),
            readOnly: true,
            decoration: const InputDecoration(
              label: Text('Health Fail URL'),
            ),
            initialValue: parameters.healthCheckUrlFail,
          ),
          TextFormField(
            key: Key(parameters.apiKey),
            readOnly: true,
            decoration: const InputDecoration(
              label: Text('API Key'),
            ),
            initialValue: parameters.apiKey,
          ),
          const SizedBox(height: 20),
          Text(
            'Service is ${parameters.serviceEnabled ? 'Enabled' : 'Disabled'}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
