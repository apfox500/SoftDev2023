import os
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
from LetterRecognition import Recognition


app = Flask(__name__)

api = Api(app)

# 1 different endpoint --> flutter app sends imag to be procssed


class Image(Resource):

    def get(self):
        return {'Realest Thing Ever Said': "Chiranth's is a cumslut"}, 200

    def post(self):
        # this is where chiranth's code is going to go or like a call to his script running in a different file
        data = request.get_json()

        # insert Cloud Python Recognition Script
        processedData = Recognition(data['imageBase64'])

        # return a JSON object with the data produced from the script
        return {
            'Libraries': processedData['Libraries:'],
            'VariablesDeclared': processedData['Variables:'],
            'UnrecognizedData': processedData['Unrecognized:'],
            'Libs': processedData['Libs'],
            'ambussin': "Oh yes Daddy"
        }, 200


# Points the Image class to the HHTPS request analyze of GET
api.add_resource(Image, "/analyze")

# run the app indefinetely to listed for requests
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
