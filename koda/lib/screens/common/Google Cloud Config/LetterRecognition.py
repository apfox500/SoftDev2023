def Recognition(image_bs64):
    import cv2
    import pytesseract
    from Translation import translator
    import base64
    from pathlib import Path

    # Opens the encoded base64 .bin file and creates a variable called 'byte'
    # which is the base64 file in the "REad in Binary" format
    # file = open(image_bs64, 'rb')
    # byte = file.read()
    # file.close()

    # This is then written onto an image called 'image.png' using the b64decode() method
    decodeit = open('image.png', 'wb')
    decodeit.write(base64.b64decode((image_bs64)))
    decodeit.close()

    # Mention the installed location of Tesseract-OCR in your system
    # pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
    # pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'

    # Read image from which text needs to be extracted
    img = cv2.imread("image.png")

    # Preprocessing the image starts
    # Convert the image to gray scale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Performing OTSU threshold
    ret, thresh1 = cv2.threshold(
        gray, 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY_INV)

    # Specify structure shape and kernel size.
    # Kernel size increases or decreases the area
    # of the rectangle to be detected.
    # A smaller value like (10, 10) will detect
    # each word instead of a sentence.
    rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (18, 18))

    # Applying dilation on the threshold image
    dilation = cv2.dilate(thresh1, rect_kernel, iterations=1)

    # Finding contours
    contours, hierarchy = cv2.findContours(dilation, cv2.RETR_EXTERNAL,
                                           cv2.CHAIN_APPROX_NONE)

    # Creating a copy of image
    im2 = img.copy()

    # A text file is created and flushed
    '''file = open("recognized.txt", "w+")
    file.write("")
    file.close()'''

    # Looping through the identified contours
    # Then rectangular part is cropped and passed on
    # to pytesseract for extracting text from it
    # Extracted text is then written into the text file
    # arr = []
    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)

        # Drawing a rectangle on copied image
        rect = cv2.rectangle(im2, (x, y), (x + w, y + h), (0, 255, 0), 2)

        # Cropping the text block for giving input to OCR
        cropped = im2[y:y + h, x:x + w]

        # Open the file in append mode
        file = open("recognized.txt", "a")

        # Apply OCR on the cropped image
        text = pytesseract.image_to_string(cropped)

        # Parse through the characters in detected words
        # Take the detected characters and form them into individual words
        arr = []  # List where individual word characters will be stored
        words = []  # List where characters will be joined into words/commands
        # For each character in the detected text the code takes the character
        # and makes sure it isn't a space or new line and puts the character into the 'arr' list
        for chr in text:
            if chr != " " and chr != "\n":
                arr.append(chr)
            # If the character is a space, the charcters that are in the arr list are all
            # joined together to form a word/command. Then the word is put into the 'words'
            # list and the 'arr' list is cleared to ready it for a new set of characters
            elif chr == " ":
                word = "".join(arr)
                words.append(word)
                arr.clear()
            # If the character is a new line, the charcters that are in the arr list are all
            # joined together to form a word/command. Then the word is put into the 'words'
            # list and the 'arr' list is cleared to ready it for a new set of characters
            # Also I had to separate these commands to make sure that everything was
            # looked at individually and not treated as a big chunk as that was causing problems
            elif chr == "\n":
                word = "".join(arr)
                words.append(word)
                arr.clear()

        # Creates an index value to parse through the 'words' list
        index = 0
        # THis loop basically just looks through the 'words' list and is a word is found
        # that is just an empty string, it removes the object at that index
        for word in words:
            if word == "":
                words.pop(index)
                index += 1
            else:
                index += 1

        # Appending the text into file
        '''file.write(text)
        file.write("\n")'''

        # Close the file
        file.close

    # Runs the translator script on the 'words' list from the "Translation.py"
    # file which currectly counts the number of variables and counts the number of
    # imported libraries as well as naming all the imported libraries
    returnedData = translator(words)
    return returnedData

# Recognition('encode.bin')
