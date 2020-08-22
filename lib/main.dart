import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: ProfilePage(), //render Profile Page
    title: 'Suwiter', //just app title
    debugShowCheckedModeBanner: false, //remove debug banner
  ));
}

class ProfilePage extends StatelessWidget {
  //dummy tweet
  final List<Tweet> tweets = <Tweet>[
    Tweet(
        text: 'Hello World!!',
        date: '1 hour ago',
        like: 230,
        comments: 34,
        share: 2),
    Tweet(
        text: 'Lorem ipsum dolor sir amet',
        date: '1 hour ago',
        like: 271,
        comments: 2,
        share: 0),
    Tweet(
        text: 'Sliver tutorial coming out soon!',
        date: '2 hour ago',
        like: 84,
        comments: 102,
        share: 33),
    Tweet(
        text:
            'SliverList determines its scroll offset by "dead reckoning" because children outside the visible part of the sliver are not materialized, which means SliverList cannot learn their main axis extent. Instead, newly materialized children are placed adjacent to existing children.',
        date: '2 hour ago',
        like: 230,
        comments: 34,
        share: 2),
    Tweet(
        text:
            'A sliver that places multiple box children in a linear array along the main axis.',
        date: '3 hour ago',
        like: 271,
        comments: 2,
        share: 0),
    Tweet(
        text:
            'Each child is forced to have the SliverConstraints.crossAxisExtent in the cross axis but determines its own main axis extent.',
        date: '4 hour ago',
        like: 84,
        comments: 102,
        share: 33),
    Tweet(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
        date: '6 hour ago',
        like: 230,
        comments: 34,
        share: 2),
    Tweet(
        text:
            'Section 1.10.32 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC',
        date: '8 hour ago',
        like: 271,
        comments: 2,
        share: 0),
    Tweet(
        text:
            'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system',
        date: '12 hour ago',
        like: 84,
        comments: 102,
        share: 33),
  ];

  //dummy user
  final User user = User(
      name: 'John Doe',
      address: 'Jakarta, IDN',
      avatar:
          'https://images.unsplash.com/photo-1596431366356-9014a7ceaafd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
      followers: 1203,
      following: 902);

  @override
  Widget build(BuildContext context) {
    //alwayd using scaffold
    return Scaffold(
      backgroundColor: Colors.white,
      //safearea to prevent overflow on notch device
      body: SafeArea(
          //because its sliver use custom scroll view
          child: CustomScrollView(
        slivers: <Widget>[
          //sliding header here, contains user information
          SliverPersistentHeader(
              pinned: true, delegate: ProfileHeader(user: user)),

          //dummy user tweets
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              Tweet tweet = tweets[index];

              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[300]))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(' . '),
                              Text(
                                tweet.date,
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(tweet.text),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconLabel(
                                label: tweet.like.toString(),
                                icon: Icons.favorite_border,
                              ),
                              IconLabel(
                                label: tweet.comments.toString(),
                                icon: Icons.alternate_email,
                              ),
                              IconLabel(
                                label: tweet.share.toString(),
                                icon: Icons.bookmark_border,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }, childCount: tweets.length),
          )
        ],
      )),
    );
  }
}

class ProfileHeader implements SliverPersistentHeaderDelegate {
  final User user; //get user info from parent
  final double _height = 350; //total header height
  final double _minHeight = 70; //on collapse height
  double imageRadius = 50; //image default radius
  double backgroundImageSize =
      0.6; //percent, white curve background height 0 - 1

  ProfileHeader({@required this.user});

  // this method will return image positioned on top side
  double getImageTop(double shrinkOffset) {
    double topPosition = 10;

    //expanded
    double shrunk = (_height - shrinkOffset) / _height; //1 - 0
    double defaultSize = (_height * (1 - backgroundImageSize)) - imageRadius;
    topPosition = defaultSize * shrunk;

    topPosition = topPosition < 10 ? 10 : topPosition;

    return topPosition;
  }

  // this method return imgae position on left side
  double getImageLeft(double shrinkOffset, BuildContext context) {
    double leftPosition = 10;

    //expanded
    double shrunk = (_height - shrinkOffset) / _height;
    double defaultSize = (MediaQuery.of(context).size.width / 2) - imageRadius;
    leftPosition = defaultSize * shrunk;

    leftPosition = leftPosition < 10 ? 10 : leftPosition;

    return leftPosition;
  }

  /* this method will get image radius */
  double getImageRadius(double shrinkOffset) {
    return shrinkOffset > _minHeight
        ? imageRadius / 2 //shrunk
        : imageRadius - (shrinkOffset / 3); //expanded
  }

/* this method will return 0 to 1, which 0 is total collapse and 1 is full expanded */
  double getShrinkPercent(double shrinkOffset) {
    double shrinkPercent = 1 - (shrinkOffset / (_height - shrinkOffset));
    shrinkPercent = shrinkPercent < 0 ? 0 : shrinkPercent;

    return shrinkPercent;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercent = getShrinkPercent(shrinkOffset);

    //Stack for profile header
    return Stack(
      children: [
        /* Contains name, followers and following on collapse/pinned  START*/
        Container(
          height: _height,
          color: Colors.blue,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Username START
              Row(
                children: [
                  SizedBox(
                    width: 75,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //Username END

              //followers and following START
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.grey[200],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        user.followers.toString(),
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.grey[200],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        user.following.toString(),
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
              //followers and following END
            ],
          ),
        ),
        /* Contains name, followers and following on collapse/pinned  END */

        /* Contains white curve background and username, address, follwers and following when header expanded START */
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(top: 60 * shrinkPercent),
            height: (_height - shrinkOffset) * backgroundImageSize,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20 * shrinkPercent),
                    topRight: Radius.circular(20 * shrinkPercent))),
            child: Opacity(
              opacity: shrinkPercent,
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    user.name.toString(),
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.address,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(user.followers.toString()),
                          Text('followers')
                        ],
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Column(
                        children: [
                          Text(user.following.toString()),
                          Text('following')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        /* Contains white curve background and username, address, follwers and following when header expanded START */

        /* only contains User Avatar START */
        Positioned(
          top: getImageTop(shrinkOffset),
          left: getImageLeft(shrinkOffset, context),
          child: Column(
            children: [
              CircleAvatar(
                radius: shrinkOffset > _minHeight
                    ? getImageRadius(shrinkOffset) + 1
                    : getImageRadius(shrinkOffset),
                backgroundColor: Colors.white,
                child: Transform.rotate(
                  angle: shrinkPercent * 6.25,
                  child: CircleAvatar(
                    radius: getImageRadius(shrinkOffset),
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                ),
              ),
            ],
          ),
        ),
        /* only contains User Avatar START */
      ],
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

//widget for per tweet like, comment and share
class IconLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  IconLabel({this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[700],
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        )
      ],
    );
  }
}

//user information class
class User {
  String name;
  String address;
  int followers;
  int following;
  String avatar;

  User({this.name, this.address, this.followers, this.following, this.avatar});
}

//tweet information class
class Tweet {
  String text;
  String date;
  int like;
  int comments;
  int share;

  Tweet({this.text, this.date, this.like, this.comments, this.share});
}
