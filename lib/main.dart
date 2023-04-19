import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Null değerler için bir extension yazdık otomatik olarak algılayacak.
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this ?? other;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

// void testIt() {
//   const int? int1 = null;
//   const int int2 = 1;
//   final result = int1 + int2;
//   print(result);
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

final currentData = Provider((ref) => DateTime.now());

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
            // Consumer Widget ağacın tekrar çizilmesini engelleyecek sadece kendi state'inde değişiklik olduğunda çizilecek.
            title: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            final text = count == null ? 'Press the Button' : count.toString();
            return Text(text);
          },
        )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
                onPressed: () => ref.read(counterProvider.notifier).increment(),
                child: const Text('Increment counter'))
          ],
        ));
  }
}
