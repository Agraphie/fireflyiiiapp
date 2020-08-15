import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fireflyapp/application.dart' as application;
import 'package:fireflyapp/domain/account/account.dart';
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
      var e = EditTransactionViewModel(c);
      Locale myLocale = Localizations.localeOf(c);
      var dateFormat = DateFormat.yMd(myLocale.toString());
      return ChangeNotifierProvider<EditTransactionViewModel>(
        create: (c) => e,
        child: EditTransactionPage(e, dateFormat),
      );
    },
  );

  final DateFormat _dateFormat;
  final EditTransactionViewModel vm;

  EditTransactionPage(this.vm, this._dateFormat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: application.neutralBackground,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: vm.addNewTransaction,
          tooltip: 'Add transaction split',
          child: const Icon(Icons.add)),
      body: StreamBuilder<EditTransactionModel>(
          stream: vm.transactionStream,
          builder: (context, transactionSnap) {
            if (!transactionSnap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListView(children: <Widget>[
                _buildGlobalInputs(context, transactionSnap.data),
                StreamBuilder<Iterable<EditTransactionModelTransaction>>(
                    initialData: transactionSnap.data.transactions,
                    stream: vm.splitTransactionsStream,
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
            );
          }),
    );
  }

  Widget _buildSingleTransaction(
      EditTransactionModelTransaction e, BuildContext context) {
    return !vm.deleteTransactionsEnabled
        ? Dismissible(
            child: _buildTransaction(e, context),
            dismissThresholds: {DismissDirection.startToEnd: 0.5},
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            key: ObjectKey(e),
            direction: vm.deleteTransactionsEnabled
                ? DismissDirection.startToEnd
                : null,
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
            })
        : Container(
            child: _buildTransaction(e, context),
          );
  }

  Widget _buildGlobalInputs(BuildContext context, EditTransactionModel e) {
    return _buildCard(
      Column(
        children: <Widget>[
          _buildFromAccount(),
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
                lastDate: DateTime(2101)),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildAttachmentSelectField(context, e),
        ],
      ),
    );
  }

  Widget _buildFromAccount() {
    TextEditingController t = TextEditingController()..text = '';
    return TypeAheadField(
      autoFlipDirection: true,
      textFieldConfiguration: TextFieldConfiguration<Account>(
          decoration: const InputDecoration(labelText: 'From'), controller: t),
      suggestionsCallback: (pattern) {
        return vm.assetAccounts
            .where((t) => t.name.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, Account suggestion) {
        return ListTile(title: Text(suggestion.name));
      },
      onSuggestionSelected: (Account suggestion) {},
    );
  }

  Widget _buildAttachmentSelectField(BuildContext c, EditTransactionModel e) {
    return Container(
      width: MediaQuery.of(c).size.width,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 3.0,
        children: <Widget>[
          Container(
            transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
            child: ClipOval(
              child: Container(
                color: Theme.of(c).accentColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FilePicker.getMultiFile().then(vm.addFiles);
                  },
                ),
              ),
            ),
          ),
          e.attachments.isNotEmpty
              ? const SizedBox()
              : const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text('Keine Anhänge'),
                ),
          ...e.attachments.map((File item) {
            return Chip(
              label: Text(item.uri.path.split('/').last),
              deleteIcon: const Icon(Icons.clear),
              deleteIconColor: Colors.white,
              onDeleted: () => vm.removeFile(item),
            );
          }),
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
          transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 5.0,
            children: <Widget>[
              ...item.tags?.map(
                (t) => Chip(
                  label: Text(t),
                  deleteIcon: const Icon(Icons.clear),
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

  EditTransactionPageArguments([this.transactionId]);
}
