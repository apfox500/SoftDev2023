enum QuestionType {
  multiple,
  select,
  matching,
  short,
  code, //NOTE - code is experimental and as of rn is unuseable
}

QuestionType findType(String type) {
  if (type == "Matching") {
    return QuestionType.matching;
  } else if (type == "Multiple Choice") {
    return QuestionType.multiple;
  } else if (type == "Short Answer") {
    return QuestionType.short;
  } else if (type == "Multiple Select") {
    return QuestionType.select;
  } else {
    return QuestionType.code;
  }
}
