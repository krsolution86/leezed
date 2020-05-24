module.exports = {
    facebookAuth: {
        clientID: process.env.FB_CLIENT_ID,
        clientSecret: process.env.FB_SECRET,
        callbackURL: process.env.FB_CALLBACK_URL,
        enableProof: false
    },
    googleAuth: {
        clientID: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_SECRET,
        callbackURL: process.env.GOOGLE_CALLBACK_URL,
        enableProof: false
    }
}