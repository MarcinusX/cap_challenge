import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

export const OnCreateFunction = functions.auth.user().onCreate((event) => {
    return admin.database().ref('users/' + event.data.uid).set({
        username: event.data.displayName,
        email: event.data.email,
    });
});

export const AddCapCode = functions.https.onRequest((request, response) => {
    let uid = request.get("uid");
    if (request.method === 'POST') {
        admin.database().ref('users/' + uid + '/bottles/').push({
            type: "COCA_COLA_500",
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