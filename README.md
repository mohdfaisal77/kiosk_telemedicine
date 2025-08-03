## Telemedicine Kiosk App

### What is this?

This is a tablet-based app that acts like a digital receptionist for hospitals and clinics. Instead of waiting in line or filling out forms, patients can walk up to a tablet, check if a doctor is available, and book an appointment — all by themselves, without needing help from staff.

---

### Why we built it

Many hospitals still rely on paper forms or ask patients to wait just to schedule an appointment. This takes time and creates unnecessary work for staff. We built this app to make things easier and faster. With this app, patients can check availability and book appointments on their own, directly from a tablet set up in a waiting area or lobby.

---

### What the app does

* Lets patients book appointments with doctors.
* Shows if a doctor is available, unavailable, or busy — in real time.
* Logs out automatically after 2 minutes of no activity (perfect for public or shared use).
* Supports both light and dark mode, depending on lighting conditions.
* Connects with a live database (Firebase) to stay updated.
* Blocks booking if the doctor isn’t available.
* Tells users when something goes wrong and guides them clearly.

---

### What you need to run this app

To get the app running, you'll need:

1. **Flutter** – a tool that lets us build mobile apps.
2. **Android Studio or Visual Studio Code** – to view or edit the app.
3. **A Firebase account** – this keeps the doctor data updated in real time.
4. **An Android device** – preferably a tablet, since this is made for kiosk use.

---

### How to set it up


You’ll download the app files, connect it to your Firebase account, and install it on a tablet. You’ll need to tell Firebase what your app’s name is, and put a small file (called `google-services.json`) in the right place. Once that's done, you can run the app and everything should work.

The app will connect to the Firebase database and show live doctor status. If a doctor is online, patients can book appointments. If they’re offline or busy, the app will show that clearly.

How to set up files code in Android studio by cloning the app from GitHub - 
---

### How to use it

After setting it up, you can log in using the default login (admin/1234), and try the following:

* Book an appointment.
* Check if the doctor is online or offline.
* Leave the app idle for 2 minutes to see if it logs out.
* Try changing the doctor’s status from the Firebase dashboard and watch the app update live.

---

### Common problems and fixes

* **App doesn’t start:** Check that everything is installed properly and your internet is working.
* **Firebase not connecting:** Make sure you copied the setup file correctly and that the project matches.
* **Doctor always shows as offline:** You may need to manually update the doctor's status in Firebase.
* **App logs out too fast or too slow:** You can adjust the logout timing in the app’s settings.

---

### How to install it on a real hospital tablet

You can connect the tablet to your computer and install the app directly. Once it’s installed, you can use a “kiosk launcher” from the Play Store to lock the tablet so only this app can be used — no other apps or settings can be accessed.

---

### Personalizing the app

You can easily make changes:

* Change the admin login username or password.
* Adjust the auto-logout timing.
* Change the colors to match your hospital’s brand.
* Add support for more languages.
* Edit the wording or messages shown on the screen.

---

### App layout

The app is organized into simple parts:

* **Screens** like login, booking, and home.
* **Controllers** that manage what the app does in the background.
* **Services** that handle communication with Firebase.
* **Theme settings** to control how the app looks.

---

### How to test doctor availability

You can log in to your Firebase account, go to your database, and change the doctor’s status between “online”, “offline”, or “busy”. The app will show these changes instantly. If a doctor is offline, patients won’t be able to book. If they’re busy, it’ll show a busy status but still allow bookings.

---

### Security features

* The app logs out automatically after 2 minutes of no use, which is helpful in public places.
* All activity is tracked in the background.
* The app can be locked to the tablet so people can’t exit or open other apps.

---

### Tips for best performance

* Use a tablet with at least a 7-inch screen.
* Android version 8.0 or higher works best.
* Make sure you have a good internet connection.
* The app is designed to use very little battery when idle.

---

### Final thoughts

This app is designed to make hospital front-desk operations smoother and faster. It’s been tested in real healthcare environments, and it's built to handle real-world issues like patients walking away mid-process or slow connections.
