import 'package:fireflyapp/application.dart' as application;
import 'package:fireflyapp/pages/transaction/edit_transaction_model.dart';
import 'package:fireflyapp/pages/transaction/edit_transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTransactionPage extends StatelessWidget {
  static const String routeName = '/transaction/';
  static final MapEntry<String, WidgetBuilder> route = MapEntry(
    routeName,
    (BuildContext c) {
      var e = EditTransactionViewModel();
      return ChangeNotifierProvider<EditTransactionViewModel>(
        create: (c) => e,
        child: EditTransactionPage(e),
      );
    },
  );
  static final _dateFormat = DateFormat.yMd();

  final EditTransactionViewModel vm;

  EditTransactionPage(this.vm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: application.neutralBackground,
      appBar: AppBar(
        actions: <Widget>[IconButton(icon: Icon(Icons.save), onPressed: () {})],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: vm.addNewTransaction,
          tooltip: 'Add transaction split',
          child: Icon(Icons.add)),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListView(children: <Widget>[
          _buildGlobalInputs(context),
          StreamBuilder<List<EditTransactionModelTransaction>>(
              stream: vm.transactionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Column(
                  children: <Widget>[
                    ...snapshot.data
                        .map((EditTransactionModelTransaction item) {
                      return _buildSingleTransaction(item, context);
                    }).toList(),
                  ],
                );
              }),
        ]),
      ),
    );
  }

  Widget _buildSingleTransaction(
      EditTransactionModelTransaction e, BuildContext context) {
    return AbsorbPointer(
      absorbing: !vm.deleteTransactionsEnabled,
      child: Dismissible(
          child: _buildTransaction(e, context),
          dismissThresholds: {DismissDirection.startToEnd: 0.5},
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          key: ObjectKey(e),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            vm.deleteTransaction(e);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: const Text('Transaktion gelöscht'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: vm.undoLastDeleteTransaction,
                ),
              ),
            );
          }),
    );
  }

  Widget _buildGlobalInputs(BuildContext context) {
    return _buildCard(
      Column(
        children: <Widget>[
          const TextField(
            decoration: InputDecoration(labelText: 'From'),
          ),
          const SizedBox(
            height: 10,
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'To'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _dateFormat.format(DateTime.now()),
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(labelText: 'Date'),
            readOnly: true,
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970, 8),
              lastDate: DateTime(2101),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _dateFormat.format(DateTime.now()),
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(labelText: 'Anhänge'),
            readOnly: true,
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970, 8),
              lastDate: DateTime(2101),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction(
      EditTransactionModelTransaction item, BuildContext context) {
    return _buildCard(
      Column(
        children: <Widget>[
          _buildDescription(item),
          const SizedBox(
            height: 10,
          ),
          _buildTransactionAmount(item),
          const SizedBox(
            height: 10,
          ),
          _buildCategoryField(item),
          const SizedBox(
            height: 10,
          ),
          _buildTagsField(item, context),
        ],
      ),
    );
  }

  Widget _buildCategoryField(EditTransactionModelTransaction item) {
    TextEditingController t = TextEditingController()
      ..text = item.category ?? '';
    return TypeAheadField(
      autoFlipDirection: true,
      textFieldConfiguration: TextFieldConfiguration<String>(
          decoration: const InputDecoration(labelText: 'Kategorie'),
          controller: t),
      suggestionsCallback: (pattern) {
        return vm.categories
            .where((t) => t.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSuggestionSelected: (String suggestion) {
        vm.updateCategory(suggestion, item);
        t.clear();
      },
    );
  }

  Widget _buildTagsField(
      EditTransactionModelTransaction item, BuildContext context) {
    TextEditingController t = TextEditingController();
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0.0),
          transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: <Widget>[
              ...item.tags?.map(
                (t) => Chip(
                  label: Text(t),
                  deleteIcon: Icon(Icons.clear),
                  deleteIconColor: Colors.white,
                  onDeleted: () => vm.removeTag(t, item),
                ),
              )
            ],
          ),
        ),
        TypeAheadField(
          autoFlipDirection: true,
          textFieldConfiguration: TextFieldConfiguration<String>(
              decoration: const InputDecoration(labelText: 'Tags'),
              controller: t),
          suggestionsCallback: (pattern) {
            return vm.tags
                .where((t) => t.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, String suggestion) {
            return ListTile(title: Text(suggestion));
          },
          onSuggestionSelected: (String suggestion) {
            vm.addTag(suggestion, item);
            t.clear();
          },
        )
      ],
    );
  }

  Widget _buildDescription(EditTransactionModelTransaction item) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Beschreibung'),
      onChanged: (s) => vm.updateDescription(s, item),
      initialValue: item.description,
    );
  }

  Widget _buildTransactionAmount(EditTransactionModelTransaction item) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Betrag'),
      initialValue: item.amount != null ? item.amount.toString() : '',
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: child,
      ),
    );
  }
}

class EditTransactionPageArguments {
  final String transactionId;

  EditTransactionPageArguments(this.transactionId);
}