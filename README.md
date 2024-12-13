# Photo Editor App

## Overview
This application allows users to register, sign in, and edit photos using various tools. It supports email and Google sign-in.

## Features
- Email and Google authentication
- Image selection from the library
- Basic image editing tools (drawing, text, filters)
- Save and export images

## Setup
1. Clone the repository.
2. Open the project in Xcode.
3. Run the project on a simulator or device.

## Architecture
- **MVVM**: The application follows the MVVM architecture.
- **Combine**: Used for state management and data binding.
- **Firebase/Auth**: For authentication.
- **Google SignIn SDK**: For Google authentication. 
- **Core Image, PencilKit**: For image editing functionalities.

## Screenshots

### 1. Registration and Sign-In Screens
The first image shows the registration flow for the app, including options for email and Google sign-in, along with pages for resetting the password and signing up with email.

![Registration and Sign-In Screens](https://github.com/user-attachments/assets/d950d89d-6a18-44e7-9136-19ee085ad35a)

### 2. Image Editor Page (Scale and Rotate)
The second image displays the image editor page, where users can change the scale and rotation of an image. It also allows users to draw on the image and upload an image from their photo library or take a new photo using the camera.

![Image Editor - Scale and Rotate](https://github.com/user-attachments/assets/b8eb8a20-5475-4081-8c26-9fd16c555121)

### 3. Image Editor Page (Save and Export)
The third image shows the final stage of image editing, where users can save the edited image to their photos after making changes like scaling, rotating, or drawing.

![Image Editor - Save and Export](https://github.com/user-attachments/assets/b37757e9-ebfe-46a6-99da-3644f4cc3f7a)
