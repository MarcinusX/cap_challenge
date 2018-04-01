import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

export const OnCreateFunction = functions.auth.user().onCreate((event) => {
    return admin.database().ref('users/' + event.data.uid).set({
        username: event.data.displayName,
        email: event.data.email,
    });
});