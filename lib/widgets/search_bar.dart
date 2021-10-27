import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function() searchOnTap;

  const SearchBar({required this.searchOnTap});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffdbdbdb)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Color(0xffb8b8b8),
              ),
              const SizedBox(width: 10,),
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(hintText: 'Search', border: InputBorder.none),
                    onTap: searchOnTap,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
