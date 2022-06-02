import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/auth/auth_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdicionarTarefaPage extends StatefulWidget {
  const AdicionarTarefaPage({Key? key}) : super(key: key);

  @override
  State<AdicionarTarefaPage> createState() => _AdicionarTarefaPageState();
}

class _AdicionarTarefaPageState extends State<AdicionarTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descricao = TextEditingController();

  _onSubmit() async {
    try {
      AuthFirebaseService firebase =
          Provider.of<AuthFirebaseService>(context, listen: false);

      DocumentReference docRef = firebase.firestore.collection('tarefas').doc();
      firebase.firestore.collection('tarefas').doc(docRef.id).set(
        {
          'refDoc': docRef.id,
          'usuario': firebase.usuario!.uid,
          'nome': _nome.text,
          'descricao': _descricao.text,
        },
      );

      Navigator.pop(context);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nova tarefa'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text('Nome')),
                      controller: _nome,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Preencha o campo corretamente!';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Descrição'),
                      ),
                      maxLines: 3,
                      controller: _descricao,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Preencha o campo corretamente!';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: () {
                  _onSubmit();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Salvar',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
