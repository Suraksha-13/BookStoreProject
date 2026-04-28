import 'package:flutter/material.dart';
import '../mainscreen.dart';


class HomePage extends StatelessWidget{

  const HomePage ({super.key});

  @override
  Widget build(BuildContext context){

    return MainScaffold(
        currentIndex: 0,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text("WELCOME TO BOOK STORE",style: TextStyle(fontSize: 20),),
                    ],
                  ),

                  const SizedBox(height: 25,),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                  Row(
                                    children: [
                                      Icon(Icons.local_fire_department_sharp),
                                      const SizedBox(width: 4,),
                                      Text("Popular")
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),

                                Text('The Book, Think\n and Grow Rich', style: TextStyle(fontSize: 17, fontWeight: .bold),),
                                const SizedBox(height: 5,),
                                Text("Napoleon Hill (1937")
                              ],
                            ),
                       const SizedBox(width: 100,),
                       Image.network("https://covers.openlibrary.org/b/isbn/9781585424337-L.jpg",
                       height: 150,)
                      ],
                    ),
                  ),

                  const SizedBox(height: 27,),
                  Text("Best Sellers", style: TextStyle(fontSize: 18, fontWeight: .bold),),


                  Container(
                    height: 220, // ✅ controls height (prevents big stretching)
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          bookItem(
                            "The Rich Dad",
                            "https://covers.openlibrary.org/b/isbn/9781612680194-L.jpg",
                          ),
                          const SizedBox(width: 15),

                          bookItem(
                            "Think and Grow Rich",
                            "https://covers.openlibrary.org/b/isbn/9781585424337-L.jpg",
                          ),
                          const SizedBox(width: 15),

                          bookItem(
                            "How to Win Friends",
                            "https://covers.openlibrary.org/b/isbn/9780671027032-L.jpg",
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 28,),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text("Explore More "),
                      const SizedBox(width: 5,),
                      Icon(Icons.arrow_circle_right_rounded),
                    ],
                  )


                ],
              ),
            )
        )
    
    );
  }

}


Widget bookItem(String title, String imageUrl) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          height: 150,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 7),
      SizedBox(
        width: 100,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    ],
  );
}
