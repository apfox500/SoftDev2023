enum Section {
  syntax,
  dataTypes,
  arithmetic,
  variables,
  commonFunctions,
  errors,
  comparisonOperators,
  ifs,
  loops,
  reference,
  functions,
  classes;

  @override
  String toString() => name;
}

Section findSection(String section) {
  if (section == "syntax") {
    return Section.syntax;
  } else if (section == "data types") {
    return Section.dataTypes;
  } else if (section == "arithmetic operators") {
    return Section.arithmetic;
  } else if (section == "variables") {
    return Section.variables;
  } else if (section == "common functions") {
    return Section.commonFunctions;
  } else if (section == "errors") {
    return Section.errors;
  } else if (section == "comparison operators") {
    return Section.comparisonOperators;
  } else if (section == "ifs") {
    return Section.ifs;
  } else if (section == "loops") {
    return Section.loops;
  } else if (section == "reference") {
    return Section.reference;
  } else if (section == "functions") {
    return Section.functions;
  } else {
    return Section.classes;
  }
}
