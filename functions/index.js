require('dotenv').config();

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

const mailTransport = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
    },
});

exports.sendVerificationCode = functions.firestore
    .document('verification_codes/{email}')
    .onCreate(async (snapshot, context) => {
        const email = context.params.email;
        const data = snapshot.data();
        const verificationCode = data.code;

        try {
            const userQuery = await admin.firestore()
                .collection('student_accounts')
                .where('email', '==', email)
                .limit(1)
                .get();

            if (userQuery.empty) {
                console.error(`No user found with email: ${email}`);
                return null;
            }
            const user = userQuery.docs[0].data();
            const firstName = user.firstName || '';

            const mailOptions = {
                from: '"Physica App" <noreply@physicaapp.com>',
                to: email,
                subject: 'Your Password Reset Verification Code',
                text: `Hello ${firstName}, \n\n`
                  + `You have requested to reset your password. Use the following verification code to continue: \n\n`
                  + `${verificationCode} \n\n`
                  + `If you did not request a password reset, please ignore this email. \n\n`
                  + `Best regards, \nPhysica App Team`,
                html: `
                  <div style="font-Family: Poppins, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
                    <div style="background-color: #1e88e5; padding: 15px; border-radius: 10px 10px 0 0; text-align: center;">
                        <h2 style="color: white; margin: 0;">Password Reset Verification</h2>
                    </div>
                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 0 0 10px 10px;">
                        <p>Hello ${firstName},</p>
                        <p>You have requested to reset your password. Use the following verification code to continue:</p>
                    <div style="background-color: #e0e0e0; padding: 15px; border-radius: 5px; text-align: center; margin: 20px 0;">
                        <h1 style="margin: 0; letter-spacing: 5px; color: #333;">${verificationCode}</h1>
                    </div>
                    <p style="font-size: 14px; color: #777;">This code will expire in 10 minutes.</p>
                    <p>If you did not request a password reset, please ignore this email.</p>
                    <p>Best regards,<br>Physica App Team</p>
                    </div>
                </div>
                `,
            };

            await mailTransport.sendMail(mailOptions);
            console.log(`Verification code email sent to: ${email}`);
            return null;
        } catch (error) {
            console.error('Error sending verification email:', error);
            return null;
        }
    });

exports.resetPassword = functions.https.onCall(async (data, context) => {
    const { email, newPassword, verificationCode } = data;

    try {
        const verificationRef = await admin.firestore()
            .collection('verification_codes')
            .doc(email);
        const verificationDoc = await verificationRef.get();

        if (!verificationDoc.exists) {
            throw new functions.https.HttpsError(
                'failed-precondition',
                'No verification found for this email.'
            );
        }

        const verificationData = verificationDoc.data();

        if (!verificationData.isUsed) {
            throw new functions.https.HttpsError(
                'failed-precondition',
                'Verification code has not been validated.'
            );
        }

        const userRecord = await admin.auth().getUserByEmail(email);

        await admin.auth().updateUser(userRecord.uid, {
            password: newPassword,
        });

        return {success: true};
    } catch (error) {
        console.error('Error resetting password: ', error);
        throw new functions.https.HttpsError(
            'internal',
            'Failed to reset password'
        );
    }
});