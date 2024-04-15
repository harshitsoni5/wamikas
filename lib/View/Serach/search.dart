import 'package:flutter/material.dart';
import 'package:wamikas/Utils/Components/Text/simple_text.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SimpleText(
        text: "Search",
        fontSize: 18,
      ),
    );
  }
}
