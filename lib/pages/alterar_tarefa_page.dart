import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/auth/auth_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AlterarTarefaPage extends StatefulWidget {
  final String refDoc;
  const AlterarTarefaPage({Key? key, required this.refDoc}) : super(key: key);

  @override
  State<AlterarTarefaPage> createState() => _AlterarTarefaPageState();
}

class _AlterarTarefaPageState extends State<AlterarTarefaPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    CollectionReference tarefas =
        FirebaseFirestore.instance.collection('tarefas');
    return FutureBuilder<DocumentSnapshot>(
      future: tarefas.doc(widget.refDoc).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Something went wrong")));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text("Document does not exist")));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final _formKey = GlobalKey<FormState>();
          final TextEditingController _nome =
              TextEditingController(text: data['nome']);
          final TextEditingController _descricao =
              TextEditingController(text: data['descricao']);

          _onSubmit() async {
            try {
              AuthFirebaseService firebase =
                  Provider.of<AuthFirebaseService>(context, listen: false);

              firebase.firestore
                  .collection('tarefas')
                  .doc(widget.refDoc)
                  .update(
                {
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

          return Scaffold(
              appBar: AppBar(
                title: const Text('Alterar tarefa'),
                centerTitle: true,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Nome')),
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

        return loading();
      },
    );
  }

  loading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.blue,
              strokeWidth: 10,
            ),
            SizedBox(height: 20),
            Text('Aguarde um momento...')
          ],
        ),
      ),
    );
  }
}
