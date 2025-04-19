# 🚗 Rent A Car – Admin App

This is the **Admin Panel App** for the `rent_a_car` project, built using **Flutter** and **Firebase**. It enables car rental administrators to manage cars, review user requests, and approve or decline bookings.

---

## 📱 Features

- 🔐 **Admin Login** using Firebase Authentication
- 🚘 **Manage Cars** – Add, Edit, Delete cars with title, type, price per day, and image URL
- 📄 **View Requests** – See all rental requests made by users
- ✅ **Approve/Decline Requests** with real-time updates
- 👤 **Admin Profile** with logout functionality

---

## 🛠️ Tech Stack

- **Flutter** (UI & App Logic)
- **Firebase Authentication** (Admin login)
- **Cloud Firestore** (Data storage)

---

## 🧪 Admin Login

> **Credentials (for testing):**

- **Email**: `admin@company.com`
- **Password**: `admin123`

> (Make sure this admin user is created in your Firebase Console under **Authentication → Users**)

---

## 🔧 How to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/rent_a_car_admin.git
   cd rent_a_car_admin

---


#Install dependencies:
    flutter pub get

---

#Connect Firebase:
    Create a Firebase project
    Add Android/iOS app
    Download google-services.json or GoogleService-Info.plist into your project
    Enable Email/Password in Firebase Auth
    Set up Firestore with cars and requests collections

---

Run the app:
    flutter run

---

📂 Project Structure (Admin Side)
    lib/
    ├── main.dart                   # Entry point
    ├── models/                    # Car and request models
    ├── services/                  # Firebase auth & Firestore logic
    ├── widgets/                   # Reusable UI components
    ├── screens/admin/             # All admin-specific screens
    └── utils/                     # Theme and other utilities

---

✅ Admin Modules Overview
    Module                  | Description
    AdminLoginScreen        | Admin login page
    AdminHomeScreen         | Dashboard for navigation
    ManageCarsScreen        | List all cars, add/edit/delete cars
    AddEditCarScreen        | Car form used for add/edit
    ManageRequestsScreen    | View all rental requests
    RequestDetailScreen     | View and take action on requests
    ProfileScreen           | Admin profile and logout

---
