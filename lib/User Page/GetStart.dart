import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';
import 'package:lottie/lottie.dart';

import 'LoginPage.dart';

class GetStart extends StatefulWidget {
  const GetStart({super.key});

  @override
  State<GetStart> createState() => _GetStartState();
}

class _GetStartState extends State<GetStart> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  PageController pageController=PageController(initialPage:0 );
  int CurrentPageIndex=0;
  List<Widget> page=[
    ImagePage( content: "Welcom To 'DailyGrocer'\n We are exicited to have you\n Onbord.", images: "assets/images/GROCERY COVER3.jpeg"),
    ImagePage(content: "We will deliver your groceries\nstraight your door step\n'Enjoy'!", images: "assets/images/GROCERY COVER3.jpg")
  ];
  void NextPage(){
    if(CurrentPageIndex < page.length -1){
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        CurrentPageIndex++;
      });
    }else {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginPage() ,));
    }
  }
  void PreviousPage(){
    if(CurrentPageIndex>0){
      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease,
      );
      setState(() {
        CurrentPageIndex++;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color:Colors.black,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    CurrentPageIndex=index;
                  });
                },children:page,
              ),
            ),
            if (CurrentPageIndex>0)
            SizedBox(width: 200,),
            Padding(
              padding: const EdgeInsets.only(left: 200,bottom: 30),
              child: ElevatedButton(onPressed: NextPage,
                  style: ElevatedButton.styleFrom(primary: Colors.amber[800],minimumSize: Size(100, 40),shape: BeveledRectangleBorder()),
                  child: Text("Next",style: TextStyle(color: Colors.black),)),
            ),
          ],
        ),
      ),
    );
  }
}





class ImagePage extends StatelessWidget {
  final String content;
  final String images;

  const ImagePage({
    Key? key,
    required this.content,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
          width: 800,
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(images),
              fit: BoxFit.cover
            )
          ),
          ),
          SizedBox(height: 30,),
          Text(
            content,
            style: TextStyle(
              fontSize: 25,
              color:Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.5
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}