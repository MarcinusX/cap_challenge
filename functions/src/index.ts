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
        points: 0,
    });
});

export const AddCapCode = functions.https.onRequest((request, response) => {
    const uid = request.get("uid");

    if (request.method === 'POST') {
        const typeChar = request.get("code").charAt(0).toLowerCase();
        const sizeChar = request.get("code").charAt(1).toLowerCase();

        const type = types[typeChar];
        const size = sizes[sizeChar];
        const name = type + size;

        if (type == null || size == null) {
            response.status(400).send("Invalid code");
            return null;
        }

        const path = 'users/' + uid;//+ '/bottles/' + type + size;
        return Promise.all([
            admin.database().ref(path + '/bottles/' + name).once('value', (snapshot) => {
                let quantity = 1;
                if (snapshot.exists()) {
                    quantity += snapshot.val();
                }
                return admin.database().ref(path + '/bottles/' + name)
                    .set(quantity)
                    .then(value => response.status(200).send(),
                        reason => response.status(500).send());
            }),
            admin.database().ref(path + '/points').once('value', (snapshot) => {
                let points = pointSheet[sizeChar];
                if (snapshot.exists()) {
                    points += snapshot.val();
                }
                return admin.database().ref(path + '/points')
                    .set(points)
                    .then(value => response.status(200).send(),
                        reason => response.status(500).send());
            }),
        ]).then(value => response.status(200).send(),
            reason => response.status(500).send());
    } else {
        response.status(404).send();
        return null;
    }

});