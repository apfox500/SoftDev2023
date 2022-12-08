import 'package:flutter/material.dart';
import 'package:koda/question.dart';
import 'package:page_transition/page_transition.dart';

import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'lesson_page.dart';
import 'question_page.dart';

//Eventually will want to have previous sections then the current one, but for now we will remain in each section

/// Navigates to the proper question or lesson within the specified [section] after the [lesson] or [question]
/// that is provided(if one is).
///
/// Both [lesson] and [question] cannot be non-null at the same time, but both can be null (for example: if leaving
/// the home page).
///
/// If [forwards] is true, then it will go fowards; If [forwards] and [backwards] are both false it will simply
/// open the current position; If [forwards] is false and [backwards] is true it will go backwards. Both
/// [forwards] and [backwards] cannot be true at the same time.
///
/// If [forwards] or [backwards] is true, then either [lesson] or [question] must be non-null.
///
/// Uses the [User] found in [global.user], so [global.user] must be non-null.
///
/// Will trasntion to the approtiate page using specified [context] and the optional [transition] type.
void navigatePage(
  Global global,
  BuildContext context,
  Section section, {
  Question? question,
  Lesson? lesson,
  bool forwards = true,
  bool backwards = false,
  PageTransitionType transition = PageTransitionType.fade,
}) {
  //Some standard error/exception stuff
  if (forwards && backwards) {
    throw Exception("Both forwards and backwards cannot be true");
  } else if (global.user == null) {
    throw Exception("User found at global.user is null. This function can only be run with a non-null user.");
  } else if (lesson != null && question != null) {
    throw Exception("Both lesson and question cannot be provided, at least one must be null.");
  } else if ((forwards || backwards) && (lesson == null && question == null)) {
    throw Exception("If forwards or backwards is true, then either lesson or question must be non-null.");
  } else {
    //TODO: complete navigatePage algorithim
    //for now I am just getting every navigate button into one function
    int currentPlace = global.currentPlace[section]!;
    Widget page = HomePage(global);

    if (forwards) {
      //The user selected a next button of some kind
      global.currentPlace[section] = currentPlace + 1;
      currentPlace = global.currentPlace[section]!;

      if (lesson != null) {
        lesson.completed = true;
        global.seenLessons.add(lesson);
        global.syncUserData();
      } else if (question != null) {
        //I'm aware there is the exception above so it could just be an else, but I'm playing it safe
        question.timesSeen++;
        question.timesPassed++;
        global.seenQuestions.add(question);
        global.syncUserData();
      }
    } else if (backwards) {
      //The user selected a back button of some kind

    } else {
      //The user isnt moving i.e. the home page
    }
    try {
      if (global.masterOrder[section]![currentPlace] is Question) {
        page = QuestionPage(global, global.masterOrder[section]![currentPlace]);
      } else if (global.masterOrder[section]![currentPlace] is Lesson) {
        page = LessonPage(global, global.masterOrder[section]![currentPlace]);
      }
    } catch (_) {} //lowkey forget why this is in a try catch, but I'm sure its important
    //I'm pretty sure that it has an exception if we are done with the masterorder

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        fullscreenDialog: true,
        child: page,
      ),
    );
  }
}
