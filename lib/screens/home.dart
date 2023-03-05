import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/services/authentication.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _todoRepository = TodoRepository();

  final _auth = Authentication();

  final _todoNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              _auth.signOut(context);
            }, icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 15, top: 18),
              child: Row(
                children: [
                  Flexible(
                    //Create a form field to get the user input
                    child: TextFormField(
                      controller: _todoNameController,
                      decoration: const InputDecoration(hintText: "Enter Todo"),
                    ),
                  ),
                  //Icon button to add the todo name to the todo list
                  IconButton(
                    //Add the todo item when button pressed
                    onPressed: () => {
                      setState((() {
                        _todoRepository.addTodo(_todoNameController.text, context).then((_) => _todoNameController.clear());
                      }))
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _todoRepository.collectionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Checkbox(
                              value: data["completedStatus"],
                              //Set the checkbox value when changing
                              onChanged: (value) {
                                setState(() {
                                  //Assign the check box value to the completedstatus
                                  if (value == true) {
                                    _todoRepository.completeTodo(data["id"], context);
                                  } else {
                                    _todoRepository.inCompletedTodo(data["id"], context);
                                  }
                                });
                              },
                            ),
                            //If checkbox clicked, line through on the todo name
                            data["completedStatus"] == true ?
                            Expanded(
                              child: ListTile(
                                  title: RichText(
                                text: TextSpan(
                                    text: data["todoName"],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w700,
                                    )),
                              )),
                            ) :
                            //If unchecked the checkbox, display the todo name
                            Expanded(
                              child: ListTile(
                                title: Text(data["todoName"]),
                              ),
                            ),
                            //If checkbox is checked, then display the delete icon button.
                            //If not display a remove circle button
                            data["completedStatus"]
                                ? IconButton(
                                    onPressed: () => {
                                      setState(() => {
                                            _todoRepository
                                                .deleteTodo(data["id"], context)
                                          }),
                                    },
                                    icon: const Icon(Icons.delete),
                                  )
                                : const Icon(Icons.remove_circle),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
