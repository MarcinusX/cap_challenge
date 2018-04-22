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

const pointSheet = {
    '1': 50,
    '2': 100,
    '3': 150,
    '4': 300,
    '5': 500,
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
        const typeChar = request.get("code").charAt(0).toLowerCase();
        const sizeChar = request.get("code").charAt(1).toLowerCase();

        const type = types[typeChar];
        const size = sizes[sizeChar];

        if (type === null || size === null) {
            response.status(400).send("Invalid code");
            return null;
        }

        const path = 'users/' + uid;//+ '/bottles/' + type + size;
        return admin.database().ref(path).once('value', (snapshot) => {
            const val = snapshot.val();
            let bottleQuantity = val.bottles[type + size];
            if (bottleQuantity === null) {
                bottleQuantity = 0;
            }
            let points = 0;
            if (snapshot.hasChild('points')) {
                points = val.points;
            }
            return Promise.all([
                admin.database().ref(path + '/bottles/' + type + size).update(bottleQuantity + 1),
                admin.database().ref(path + '/points').update(points + pointSheet[sizeChar])]
            ).then((value) => response.status(200).send());
        });
    } else {
        response.status(404).send();
        return null;
    }

});