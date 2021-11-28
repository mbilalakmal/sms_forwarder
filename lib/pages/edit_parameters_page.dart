import 'package:flutter/material.dart';
import 'package:sms_forwarder/models/app_parameters.dart';
import 'package:sms_forwarder/services/parameters_service.dart';
import 'package:sms_forwarder/services/sms_handler_service.dart';
import 'package:sms_forwarder/utils.dart';
import 'package:telephony/telephony.dart';

class EditParametersPage extends StatefulWidget {
  const EditParametersPage({
    Key? key,
    required this.parameters,
  }) : super(key: key);

  final AppParameters? parameters;

  @override
  _EditParametersPageState createState() => _EditParametersPageState();
}

class _EditParametersPageState extends State<EditParametersPage> {
  String? _smsUrl;
  String? _healthCheckUrlOk;
  String? _healthCheckUrlFail;
  String? _apiKey;
  bool _startService = true;

  bool _shouldShowLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _smsUrl = widget.parameters?.smsUrl;
    _healthCheckUrlFail = widget.parameters?.healthCheckUrlFail;
    _healthCheckUrlOk = widget.parameters?.healthCheckUrlOk;
    _apiKey = widget.parameters?.apiKey;
    _startService = widget.parameters?.serviceEnabled ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Parameters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: _shouldShowLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// smsUrl
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('SMS URL'),
                        hintText: 'https://someservice.internal.com/messages',
                      ),
                      validator: Validator.validateURL,
                      onChanged: (val) {
                        setState(() {
                          _smsUrl = val;
                        });
                      },
                      initialValue: _smsUrl,
                    ),
                    const SizedBox(height: 8.0),

                    /// healthCheckUrlOk
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Health Okay URL'),
                        hintText: 'https://someservice.internal.com/okay',
                      ),
                      validator: Validator.validateURL,
                      onChanged: (val) {
                        setState(() {
                          _healthCheckUrlOk = val;
                        });
                      },
                      initialValue: _healthCheckUrlOk,
                    ),

                    const SizedBox(height: 8.0),

                    /// healthCheckUrlFail
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Health Fail URL'),
                        hintText: 'https://someservice.internal.com/dead',
                      ),
                      validator: Validator.validateURL,
                      onChanged: (val) {
                        setState(() {
                          _healthCheckUrlFail = val;
                        });
                      },
                      initialValue: _healthCheckUrlFail,
                    ),

                    const SizedBox(height: 8.0),

                    /// apiKey
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('API Key'),
                        hintText: 'AIZx0123qwerty',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'API key can\'t be empty';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _apiKey = val;
                        });
                      },
                      initialValue: _apiKey,
                    ),
                    const SizedBox(height: 8.0),

                    /// serviceEnabled
                    SwitchListTile.adaptive(
                      title: const Text('Enable service'),
                      value: _startService,
                      onChanged: (val) => setState(
                        () => _startService = val,
                      ),
                    ),
                    const Spacer(),

                    ElevatedButton(
                      onPressed: _onPressed,
                      child: const Text('Save'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// Validate and save parameters to local storage
  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate() == false) return;

    /// Show loading
    setState(() => _shouldShowLoading = true);

    /// Save parameters to Hive box
    final parameters = AppParameters(
      apiKey: _apiKey!,
      smsUrl: _smsUrl!,
      healthCheckUrlOk: _healthCheckUrlOk!,
      healthCheckUrlFail: _healthCheckUrlFail!,
      serviceEnabled: _startService,
    );
    await ParametersService.saveParametersToBox(parameters);

    /// Add background listener based on parameters
    if (_startService) {
      Telephony.instance.listenIncomingSms(
        onNewMessage: backgroundSmsHandler,
        onBackgroundMessage: backgroundSmsHandler,
        listenInBackground: true,
      );
    } else {
      Telephony.instance.listenIncomingSms(
        onNewMessage: (_) {},
        onBackgroundMessage: null,
        listenInBackground: false,
      );
    }

    /// Hide loading
    setState(() => _shouldShowLoading = false);

    /// Navigate back
    Navigator.pop(context);
  }
}

/// top level function called in background
backgroundSmsHandler(SmsMessage smsMessage) async {
  final message = MessageParsing.fromSmsMessage(smsMessage);

  final parameters = await ParametersService.getStoredParameters();

  if (parameters == null || parameters.serviceEnabled == false) {
    /// Don't call the POST method
    return;
  }

  await SmsHandlerService.postSms(
    parameters: parameters,
    message: message,
  );
}
