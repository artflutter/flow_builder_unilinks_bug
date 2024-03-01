import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile {
  const Profile({this.name, this.age, this.weight});

  final String? name;
  final int? age;
  final int? weight;

  Profile copyWith({String? name, int? age, int? weight}) {
    return Profile(
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
    );
  }
}

class NameForm extends StatefulWidget {
  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  var _name = '';

  void _continuePressed() {
    context.flow<Profile>().update((profile) => profile.copyWith(name: _name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) => setState(() => _name = value),
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'John Doe',
              ),
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: _name.isNotEmpty ? _continuePressed : null,
            )
          ],
        ),
      ),
    );
  }
}

class AgeForm extends StatefulWidget {
  @override
  _AgeFormState createState() => _AgeFormState();
}

class _AgeFormState extends State<AgeForm> {
  int? _age;

  void _continuePressed() {
    context.flow<Profile>().complete((profile) => profile.copyWith(age: _age));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age')),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) => setState(() => _age = int.parse(value)),
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: '42',
              ),
              keyboardType: TextInputType.number,
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: _age != null ? _continuePressed : null,
            )
          ],
        ),
      ),
    );
  }
}

class MyFlow extends StatefulWidget {
  @override
  State<MyFlow> createState() => _MyFlowState();
}

class _MyFlowState extends State<MyFlow> {
  late FlowController<Profile> _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlowController(const Profile());
  }

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<Profile>(
      state: const Profile(),
      onGeneratePages: (profile, pages) {
        return [
          MaterialPage(child: NameForm()),
          if (profile.name != null) MaterialPage(child: AgeForm()),
        ];
      },
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
