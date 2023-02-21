def translator(set):
    import json
    numWords = len(set)
    file = open("translated.txt", "w+")
    file.write("")
    file.close()
    num = importedLibraries(set)
    numWords -= num
    value = numVariables(set)
    numWords -= (value*2)
    # variableType(set, value)
    file = open("translated.txt", "a")
    file.write("\nUnrecognized: " + str(numWords) +
               " words/commands were unrecognized")
    file.close()
    descSet = []
    chars = []
    lineSet = []

    # lineWordCount = 0
    with open('translated.txt') as fl:
        data = fl.read()
        wordCount = 0
        for letter in data:
            if letter != '\n' and letter != ' ':
                chars.append(letter)
            elif letter == ' ':
                sentence = "".join(chars)
                lineSet.append(sentence)
                chars.clear()
            elif letter == '\n':
                sent = "".join(chars)
                lineSet.append(sent)
                chars.clear()
        sent = "".join(chars)
        lineSet.append(sent)
        chars.clear()

        for word in lineSet:
            if word != '':
                wordCount += 1
            elif word == '':
                descSet.append(wordCount)
                wordCount -= wordCount
        descSet.append(wordCount)
        wordCount -= wordCount
    fl.close()

    # Python program to convert text
    # file to JSON
    # the file to be converted to
    # json format
    filename = 'translated.txt'

    # dictionary where the lines from
    # text will be stored
    dict1 = {}

    commands = ['Libraries', 'Variables', 'Unrecognized']

    # creating dictionary
    with open(filename) as fh:
        for line in fh:
            if line != '\n':
                # reads each line and trims of extra the spaces
                # and gives only the valid words
                command, description = line.strip().split(None, 1)
                dict1[command] = description.strip()

    # creating json file
    # the JSON file is named as test1
    out_file = open("completed.json", "w")
    json.dump(dict1, out_file, indent=4, sort_keys=False)
    out_file.close()
    # print(dict1)
    return dict1


def importedLibraries(ls):
    ind = 0
    libs = []
    count = 0
    for arg in ls:
        if arg == "import":
            count += 2
            library = ls[ind + 1]
            libs.append(library)
            if ls[ind + 2] == "as":
                count += 2
            elif ls[ind - 2] == "from":
                count += 2
            ind += 1
        else:
            ind += 1
    file = open("translated.txt", "a")
    imported = ", ".join(libs)
    resultant = "Libraries: The 'import' command has imported the following libraries to the Python file: " + imported
    file.write(resultant + "\n\n")
    file.close()
    return count


def numVariables(ls):
    count = 0
    for arg in ls:
        for char in arg:
            if char == "=":
                count += 1
    file = open("translated.txt", "a")
    resultant = "Variables: " + str(count) + " variables have been declared\n"
    file.write(resultant)
    file.close()
    return count


def variableType(ls, num):
    stringCount = 0
    intCount = 0
    listCount = 0
    boolCount = 0
    floatCount = 0
    list = ls
    for arg in ls:
        for char in arg:
            if char == "=":
                index = list.index(arg)
                print(index)
                string = list[index + 1]
                try:
                    int(string)
                    flag = True
                    if flag == True:
                        for chr in string:
                            if chr == ".":
                                float = True
                                floatCount += 1
                                num -= 1
                        if float != True:
                            intCount += 1
                            num -= 1
                except ValueError:
                    flag = False
                    if string[0] == '"':
                        stringCount += 1
                        num -= 1
                    elif string[0] == "[":
                        listCount += 1
                        num -= 1
                    elif string == ("True" or "False"):
                        boolCount += 1
                        num -= 1
    file = open("translated.txt", "a")
    resultant = (str(stringCount) + " strings have been declared\n" +
                 str(intCount) + " integers have been declared\n" +
                 str(listCount) + " lists have been declared\n" +
                 str(boolCount) + " booleans have been declared\n" +
                 str(floatCount) + " floats have been declared\nand " +
                 str(num) + " other or unrecognized variables have been initialized \n\n")
    file.write(resultant)
    file.close()
