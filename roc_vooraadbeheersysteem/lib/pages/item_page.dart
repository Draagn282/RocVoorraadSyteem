import 'package:flutter/material.dart';
import 'package:roc_vooraadbeheersysteem/pages/base_page.dart';

class ItemPage extends BasePage {
  const ItemPage({Key? key}) : super(key: key);

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Item Page',
        style: TextStyle(color: Color(0xff3f2e56)),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Text(
                'Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Text(
                'Sample Item',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'This is a description of the sample item. It provides more details about the item.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                'Price:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Text(
                '\$99.99',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add your edit logic here
            },
            child: const Text('Edit Item'),
          ),
        ],
      ),
    );
  }
}
