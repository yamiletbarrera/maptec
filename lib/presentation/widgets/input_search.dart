import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:maptec/blocs/input_search_bloc.dart';

TextEditingController _typeAheadController = TextEditingController();

class InputSearch extends StatefulWidget {
  //String _label;

  InputSearch({Key? key}) : super(key: key);

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  int switchOpc = 1;
  List<IconData> icons = [
    Icons.location_city,
    Icons.biotech,
    Icons.video_label,
    Icons.meeting_room
  ];
  List<String> labels = [
    "un departamento",
    "un laboratorio",
    "una sala audiovisual",
    "un cubículo"
  ];

  changeSwitch(int opc) {
    switchOpc = opc;
  }

  @override
  Widget build(BuildContext context) {
    final input = Provider.of<InputSearchBloc>(context);
    _typeAheadController.selection = TextSelection.fromPosition(
        TextPosition(offset: _typeAheadController.text.length));

    return Material(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: TypeAheadField(
        getImmediateSuggestions: false,
        debounceDuration: const Duration(milliseconds: 500),
        hideOnEmpty: false,
        hideOnLoading: true,
        keepSuggestionsOnSuggestionSelected: false,
        keepSuggestionsOnLoading: false,
        suggestionsCallback: (pattern) async {
          return await input.search(pattern);
        },
        itemBuilder: (context, entidad) {
          return ListTile(
            leading: Icon(
              icons[switchOpc - 1],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text("${entidad.nombre}"),
            subtitle: Text('${entidad.edificio?.nombre}'),
          );
        },
        onSuggestionSelected: (entidad) {
          input.setSelectedEntity(entidad);
          _typeAheadController.text = entidad.nombre.toString();
        },
        errorBuilder: (context, error) =>
            ErrorOrNotFound(input: input, error: error),
        noItemsFoundBuilder: (context) => ErrorOrNotFound(input: input),
        loadingBuilder: (context) => Text(input.messageError),
        textFieldConfiguration: TextFieldConfiguration(
          controller: _typeAheadController,
          decoration: InputDecoration(
            hintText: "Busca aquí ${labels[switchOpc - 1]}",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            prefixIcon: Icon(
              Icons.place,
              color: input.selectedData != null
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.manage_search,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => modalFilterInput(context),
              tooltip: "Filtros de busqueda",
            ),
            //errorText: input.messageError != "ninguno" ? input.messageError : null,
            //errorStyle: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ),
    );
  }

  Future<void> modalFilterInput(BuildContext context) {
    final input = Provider.of<InputSearchBloc>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            title: const Text("Filtros de busqueda"),
            content: Container(
              margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: Icon(icons[0]),
                      title: const Text("Departamentos"),
                      subtitle: const Text("Buscar solo departamentos"),
                      trailing: Switch(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: switchOpc == 1 ? true : false,
                        onChanged: (value) {
                          //Limpiamos el input
                          _typeAheadController.text = "";
                          input.setSelectedEntity(null);
                          input.setSearchedData([]);
                          //Asignamos el nuevo tipo de busqueda
                          setState(() {
                            changeSwitch(1);
                          });
                          input.setTypeSearch(1);
                          Navigator.pop(context);
                        },
                      ),
                      onTap: () {
                        //Limpiamos el input
                        _typeAheadController.text = "";
                        input.setSelectedEntity(null);
                        input.setSearchedData([]);
                        //Asignamos el nuevo tipo de busqueda
                        setState(() {
                          changeSwitch(1);
                        });
                        input.setTypeSearch(1);
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: Icon(icons[1]),
                    title: const Text("Laboratorios"),
                    subtitle: const Text("Buscar solo laboratorios"),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: switchOpc == 2 ? true : false,
                      onChanged: (value) {
                        //Limpiamos el input
                        _typeAheadController.text = "";
                        input.setSelectedEntity(null);
                        input.setSearchedData([]);
                        //Asignamos el nuevo tipo de busqueda
                        setState(() {
                          changeSwitch(2);
                        });
                        input.setTypeSearch(2);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      //Limpiamos el input
                      _typeAheadController.text = "";
                      input.setSelectedEntity(null);
                      input.setSearchedData([]);
                      //Asignamos el nuevo tipo de busqueda
                      setState(() {
                        changeSwitch(2);
                      });
                      input.setTypeSearch(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                      leading: Icon(icons[2]),
                      title: const Text("Salas Audiovisuales"),
                      subtitle: const Text("Buscar solo salas audiovisuales"),
                      trailing: Switch(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: switchOpc == 3 ? true : false,
                        onChanged: (value) {
                          //Limpiamos el input
                          _typeAheadController.text = "";
                          input.setSelectedEntity(null);
                          input.setSearchedData([]);
                          //Asignamos el nuevo tipo de busqueda
                          setState(() {
                            changeSwitch(3);
                          });
                          input.setTypeSearch(3);
                          Navigator.pop(context);
                        },
                      ),
                      onTap: () {
                        //Limpiamos el input
                        _typeAheadController.text = "";
                        input.setSelectedEntity(null);
                        input.setSearchedData([]);
                        //Asignamos el nuevo tipo de busqueda
                        setState(() {
                          changeSwitch(3);
                        });
                        input.setTypeSearch(3);
                        Navigator.pop(context);
                      }),
                  ListTile(
                      leading: Icon(icons[3]),
                      title: const Text("Cubículos"),
                      subtitle: const Text("Buscar solo cubículos"),
                      trailing: Switch(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: switchOpc == 4 ? true : false,
                        onChanged: (value) {
                          //Limpiamos el input
                          _typeAheadController.text = "";
                          input.setSelectedEntity(null);
                          input.setSearchedData([]);
                          //Asignamos el nuevo tipo de busqueda
                          setState(() {
                            changeSwitch(4);
                          });
                          input.setTypeSearch(4);
                          Navigator.pop(context);
                        },
                      ),
                      onTap: () {
                        //Limpiamos el input
                        _typeAheadController.text = "";
                        input.setSelectedEntity(null);
                        input.setSearchedData([]);
                        //Asignamos el nuevo tipo de busqueda
                        setState(() {
                          changeSwitch(4);
                        });
                        input.setTypeSearch(4);
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              )
            ],
          );
        });
  }
}

class ErrorOrNotFound extends StatelessWidget {
  InputSearchBloc? input;
  Object? error;
  //Constructor with key and optional parameters
  ErrorOrNotFound({Key? key, this.input, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 80,
            ),
            const SizedBox(
              height: 2,
              width: double.infinity,
            ),
            Text(
              "${input?.messageError} 😬",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              softWrap: true,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ));
  }
}
