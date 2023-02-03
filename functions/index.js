const functions = require('firebase-functions');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { HttpsError } = require('firebase-functions/v1/auth');

const admin = initializeApp();
const db = getFirestore(admin);

exports.validateNewUser = functions.auth.user().beforeCreate((user) => {
  const email = user.email || '';

  if (!email.includes('nitc.ac.in')) {
    throw new HttpsError(
      'invalid-argument',
      'Only nitc.ac.in emails are allowed'
    );
  }
});

exports.addUserToDatabase = functions.auth.user().onCreate((user) => {
  const email = user.email || '';
  const displayName = user.displayName || 'Anonymous';
  const photoURL =
    user.photoURL ||
    'https://firebasestorage.googleapis.com/v0/b/raven-for-nitc.appspot.com/o/profile_placeholder.png?alt=media&token=a9d775ca-2f27-439c-aebc-3e86425f4be7';

  return db.collection('users').doc(user.uid).set({
    displayName,
    email,
    photoURL,
    role: 'STUDENT',
    mess: null,
  });
});
