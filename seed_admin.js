const fs = require('fs');
const path = require('path');

const serviceAccountPath = './doctor-oncall-portal-firebase-adminsdk-fbsvc-7caa28ca59.json';

if (!fs.existsSync(serviceAccountPath)) {
  console.error('\x1b[31m%s\x1b[0m', 'Error: serviceAccountKey.json not found!');
  console.log('\x1b[33m%s\x1b[0m', 'To fix this:');
  console.log('1. Go to Firebase Console > Project Settings > Service Accounts.');
  console.log('2. Click "Generate new private key".');
  console.log(`3. Rename the downloaded file to "serviceAccountKey.json" and place it in: ${path.resolve('.')}`);
  process.exit(1);
}

const admin = require('firebase-admin');
const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const seedAdmin = async () => {
  const username = "admin";
  const email = `${username}@doctor-oncall.app`;
  const password = "admin12345";
  const role = "admin";

  try {
    // Create or update user in Firebase Auth
    let userRecord;
    try {
      userRecord = await admin.auth().getUserByEmail(email);
      console.log('User already exists, updating...');
      userRecord = await admin.auth().updateUser(userRecord.uid, {
        password: password,
      });
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        userRecord = await admin.auth().createUser({
          email: email,
          password: password,
          displayName: 'Admin User',
        });
        console.log('User created successfully');
      } else {
        throw error;
      }
    }

    // Set custom claims for role-based access control
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: role });
    console.log(`Custom claims set for ${role}`);

    // Create/Update user document in Firestore
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      email: email,
      role: role,
      username: username,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    console.log('Firestore document updated');
    console.log('Admin seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding admin:', error);
    process.exit(1);
  }
};

seedAdmin();
