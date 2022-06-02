import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/auth/auth_firebase_service.dart';
import 'package:crud_firebase/pages/adicionar_tarefa_page.dart';
import 'package:crud_firebase/pages/alterar_tarefa_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchtxt = '';

  excluir(String refDoc, String nome) async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    await firebase.firestore
        .collection('tarefas')
        .doc(refDoc)
        .delete()
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$nome foi excluido com sucesso!'),
              backgroundColor: Colors.red[400],
            ),
          ),
        )
        .onError(
          (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red[400],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Tarefas'),
        centerTitle: true,
        toolbarHeight: 130,
      ),
      drawer: NavigationDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebase.firestore
            .collection('tarefas')
            .where('usuario', isEqualTo: firebase.usuario!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Column(
                  children: [
                    ListTile(
                      title: Text(data['nome']),
                      subtitle: Text(data['descricao']),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlterarTarefaPage(
                                            refDoc: data['refDoc'],
                                          )));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.amber[400],
                            ),
                          ), // icon-1
                          IconButton(
                            onPressed: () {
                              excluir(data['refDoc'], data['nome']);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                            ),
                          ), // icon-2
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdicionarTarefaPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          buildMenuItems(context),
        ]),
      ),
    );
  }

  @override
  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 24,
        left: 24,
        top: 40,
      ),
      child: Wrap(
        runSpacing: 10,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Tarefas'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            ),
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await context.read<AuthFirebaseService>().logout();
            },
          ),
        ],
      ),
    );
  }
}
