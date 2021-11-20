import 'package:flutter/material.dart';
import '../models/servicio_model.dart';
import '../providers/servicio_provider.dart';
import 'nuevo_servicio.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:json_table/json_table.dart';

class listadoVEN_Servicio extends StatefulWidget {
  String titulo;
  final _provider = new VEN_ServicioProvider();
  List<Servicio> oListaVEN_Servicio = [];
  int codigoVEN_ServicioSeleccionado = 0;
  Servicio oServicio = Servicio();
  String jSonVEN_Servicio = "";
  listadoVEN_Servicio(this.titulo);
  @override
  State<StatefulWidget> createState() => _ListadoVEN_Servicio();
}

class _ListadoVEN_Servicio extends State<listadoVEN_Servicio> {
  final _tfCliente = TextEditingController();
  final _tfOrden = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
  }

  Future<String> _consultarRegistros() async {
    Servicio pServicio = Servicio();
    pServicio.inicializar();
    pServicio.nombreCliente = _tfCliente.text;
    pServicio.numeroOrdenServicio = _tfOrden.text;

    var oListaVEN_ServicioTmp = await widget._provider.listar(pServicio);
    // ignore: avoid_print
    print(oListaVEN_ServicioTmp);
    setState(() {
      widget.oListaVEN_Servicio = oListaVEN_ServicioTmp;
      widget.jSonVEN_Servicio = widget._provider.jsonResultado;
      if (widget.oListaVEN_Servicio.length == 0) {
        widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
      }
    });
    return "Procesado";
  }

  void _nuevoRegistro() {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", 0);
    }));
  }

  void _verRegistro(int pCodigoCliente) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", pCodigoCliente);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jSonVEN_Servicio);
    return Scaffold(
        appBar: AppBar( 
          title: const Text("Consulta de Servicios "),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Para consultar completar el Nombre del cliente y Orden y dar click en consultar",
                style: TextStyle(fontSize: 12),
              ),
              TextField(
                  controller: _tfCliente,
                  decoration: const InputDecoration(
                    hintText: "Ingrese Cliente ",
                    labelText: "Cliente",
                  )),
              TextField(
                  controller: _tfOrden,
                  decoration: const InputDecoration(
                    hintText: "Ingrese Orden ",
                    labelText: "Orden",
                  )),
              Text(
                "Se encontraron " +
                    widget.oListaVEN_Servicio.length.toString() +
                    " Clientes",
                style: const TextStyle(fontSize: 9),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,                
                  children: [
                    MaterialButton(
                      minWidth: 180.0,
                      height: 40.0,
                      onPressed: _consultarRegistros,
                      color: Colors.greenAccent,                    
                      child: const Text('Consultar'),
                    ),

                    MaterialButton(                
                      minWidth: 180.0,
                      height: 40.0,
                      onPressed: _nuevoRegistro,
                      color: Colors.greenAccent,
                      child: const Text('Nuevo'),
                    ),
                  ],
                ),
              ),
              JsonTable(
                json,
                columns: [
                  JsonTableColumn("CodigoServicio", label: "CodigoServicio"),
                  JsonTableColumn("NombreCliente", label: "NombreCliente"),
                  JsonTableColumn("NumeroOrdenServicio", label: "NumeroOrdenServicio"),
                  JsonTableColumn("FechaProgramada", label: "FechaProgramada"),
                  JsonTableColumn("Linea", label: "Linea"),
                  JsonTableColumn("Estado", label: "Estado"),
                  JsonTableColumn("Observaciones", label: "Observaciones"),
                ],
                showColumnToggle: false,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500]!.withOpacity(0.7),
                paginationRowCount: 10,
                onRowSelect: (index, map) {
                  _verRegistro(int.parse(map["CodigoServicio"].toString()));
                },
              ),
            ],
          ),
        ));
  }
}
