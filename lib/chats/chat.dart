import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
export 'chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

 User? logedUser;

class ChatWidget extends StatefulWidget {
 static const String id='chatWidget';

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final textController = TextEditingController();
 
  

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

void getCurrentUser()async{
  try{
  final user1 = await _auth.currentUser;
  if(user1 !=null){
   logedUser = user1;
  }
  }catch(e){
    print(e);
  }
}

// void messageStream()async{
//  await for(var snapshot in _firestore.collection('message').snapshots()){
// for(var document in snapshot.docs){
//   print(document.data());
// }
//  }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
      appBar: AppBar(
        backgroundColor: Color(0xFF4CD54A),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent
        ),
        title: Align(
          alignment: AlignmentDirectional(-0.1, -0.05),
          child: Text(
            'Chat',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                ),
          ),
        ),
         actions: [
          IconButton(onPressed: (() {
           // messageStream();
          }), icon: Icon(Icons.logout))
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
         // onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Align(
            alignment: AlignmentDirectional(-0.65, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
      //TEXT HERE
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('message').orderBy('timestamp',descending: true).snapshots(),
              builder:((context, snapshot) {
                if(snapshot.hasData){
                  final messages = snapshot.data?.docs;
                  List<messageBubble> messageBubbles=[];

                  for(var message in messages!){
                    final messageData = message.data();
                    final messageText = messageData['text']??'';
                    final messageSender = messageData['sender']??'';

                    final currentuser = logedUser?.email;
                    // if(currentuser == messageSender){
                    //   //user loged in
                    // }
                    
                    final newmessageBubble = messageBubble(
                      sender: messageSender,
                       text: messageText,
                       isMe: currentuser == messageSender,
                       );

                    messageBubbles.add(newmessageBubble);
                  }
                  return Expanded(
                    child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        children: messageBubbles,
                    ),
                  );
                }
                
                throw Exception('Widget must not be null');
              }
              ) ),
                Align(
                  alignment: AlignmentDirectional(-0.1, 0.95),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Enter  Your text here !!...',
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        filled: true,
                        fillColor: Color.fromARGB(153, 218, 214, 214),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4CD54A),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                         suffixIcon: IconButton(
                          onPressed:()async{
                            print(textController.text);
                            print(logedUser?.email);
                            _firestore.collection('message').add({
                              'text': textController.text,
                              'sender': logedUser?.email,
                              'timestamp': DateTime.now(),
                             }
                          );
                           textController.clear();
                         }, 
                         icon: Icon(Icons.near_me_outlined,
                         size: 30,
                         color: Colors.purple,)
                      
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                    //  validator:
                      //    _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget{
  messageBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;
@override
Widget build(BuildContext context){
  return  Padding(
    padding: EdgeInsets.all(19.0),
    child: Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        Text('$sender', style: TextStyle(fontSize: 12,color: Colors.black54),),
        Material(
          borderRadius: isMe ?BorderRadius.only(
            topLeft:Radius.circular(30), 
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
            ):BorderRadius.only(
            topRight:Radius.circular(30), 
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
            ),
          elevation: 10,
          color: isMe? Color(0xFF4CD54A):Colors.white,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Text(
              '$text',
              style:TextStyle(
                fontSize: 15,
                color:isMe? Colors.white: Colors.black54
                )),
          ),
        ),
     
      ],
    ),
  );
}
}
