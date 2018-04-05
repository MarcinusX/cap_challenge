import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

const types = {
    'c': 'COCA_COLA',
    's': 'SPRITE',
    'f': 'FANTA',
    'z': 'ZERO',
    'l': 'LIGHT',
};

const sizes = {
    '1': '_250',
    '2': '_300',
    '3': '_500',
    '4': '_1L',
    '5': '_2L'
};


export const OnCreateFunction = functions.auth.user().onCreate((event) => {
    return admin.database().ref('users/' + event.data.uid).set({
        username: event.data.displayName,
        email: event.data.email,
    });
});

export const AddCapCode = functions.https.onRequest((request, response) => {
    const uid = request.get("uid");

    if (request.method === 'POST') {
        const type = types[request.get("code").charAt(0).toLowerCase()];
        const size = sizes[request.get("code").charAt(1).toLowerCase()];

        if (type == null || size == null) {
            response.status(400).send("Invalid code");
            return;
        }

        admin.database().ref('users/' + uid + '/bottles/').push({
            type: type + size,
            addTimestamp: admin.database.ServerValue.TIMESTAMP
        }).then((value => {
            response.status(200).send();
        }), (value) => {
            response.status(500).send();
        });
    } else {
        response.status(404).send();
    }

});