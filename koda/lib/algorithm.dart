import 'package:flutter/material.dart';
import 'package:koda/question.dart';
import 'package:page_transition/page_transition.dart';

import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'lesson_page.dart';
import 'question_page.dart';

//Eventually will want to have previous sections then the current one, but for now we will remain in each section
//TODO: complete navigatePage algorithim

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
/// [backToLesson] can only be true if [backwards] is true and [forwards] is false.
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
  bool backToLesson = false,
  PageTransitionType transition = PageTransitionType.fade,
}) {
  //Our constant variables to use in ratios
  const int numStartUpQuestions = 10;

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
    if (global.priority.isEmpty) {
      //tradtioional masterOrder nivgation practices
      int currentPlace = global.currentPlace[section]!;
      Widget page = HomePage(global);

      if (forwards) {
        //The user selected a next button of some kind
        global.currentPlace[section] = currentPlace + 1;
        currentPlace = global.currentPlace[section]!;

        if (lesson != null) {
          //Its a lesson
          lesson.completed = true;
          global.seenLessons.add(lesson);
          global.syncUserData();
        } else if (question != null) {
          //Its a question
          //I'm aware there is the exception above so it could just be an else, but I'm playing it safe

        }
      } else if (backwards) {
        //The user selected a back button of some kind
        global.currentPlace[section] = currentPlace - 1;
        currentPlace = global.currentPlace[section]!;
      } else {
        //The user isnt moving i.e. the home page
      }
      global.syncUserData();
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
    } else {
      //Priority is not empty, so we navigate using those
      if (global.priority[0] == question) {
        //we just did one of the questions
        if (forwards) {
          global.priority.removeAt(0);
          if (global.priority.isEmpty) {
            //we finished them, so now we just make the standard call to navigatePage
            navigatePage(global, context, section); //not forwards b/c this is as if they just started
          } else {}
        } else {
          //we have to find the lesson somehow and navigate to that temporarily
        }
      } else {
        //we are just starting the priority list
      }
    }
  }
}

/*
Plan for the algorithim:
higher pass rate-> less questions for that section
higher pass rate-> higher difficulty for questions shown in that section

every 5 usual lessons, have 2 questions from question bank
 - section based on pass rate
 - then difficulty

every day do 15 questions - notification somehow
 - 5-10 random questions on first open of the day

profile - needs to track if they have opened the day yet(lastDay opened?)
need to weight how many sections they have unlocked and how many completed too

have a storage list for random questions that reloads at start of every day. prioritize going thorugh that list first, then on doing masterlist for whateverr section they are on
have a counter for every normal lesson/question they have seen, when it passes 5 we reload that prioritized list with new questions to spice things up

profile streak counter - need to hit X questions every day(have some way to display it too)

have a third list(or just object) for going back to lessons, so then when doing the daily questions and they hit 
go back to question it will find that lesson, and when they hit next it will resume current progress in priority
*/