To create OAuth 2.0 client credentials in the Google Cloud Console, follow these steps:

1. **Go to the Google Cloud Console:**
   Visit [https://console.cloud.google.com/](https://console.cloud.google.com/) and log in with your Google account.

2. **Create a new project:**
   If you don't have an existing project, you'll need to create a new one. Click on the project dropdown in the top navigation bar and select "New Project." Follow the prompts to create a new project.

3. **Enable the People API:**

   - In the left sidebar, navigate to "APIs & Services" > "Dashboard."
   - Click on the "+ ENABLE APIS AND SERVICES" button.
   - Search for "People API" and select it.
   - Click the "Enable" button.

4. **Create OAuth 2.0 Credentials:**

   - In the left sidebar, navigate to "APIs & Services" > "Credentials."
   - Click on the "Create Credentials" button and select "OAuth client ID."

5. **Configure the OAuth consent screen:**

   - If prompted, configure the OAuth consent screen. This is the information that users will see when they are asked to grant permissions.
   - Fill in the required fields such as "Application name" and "Authorized domains."

6. **Choose application type:**

   - Select "Web application" as the application type.

7. **Configure the Authorized redirect URIs:**

   - In the "Authorized redirect URIs" section, enter the callback URL where Google will redirect users after they grant/deny permission. For development, you can use `http://localhost:3000/auth/google_oauth2/callback`.

8. **Click "Create":**

   - After configuring the necessary settings, click the "Create" button.

9. **Note the Client ID and Client Secret:**

   - Once the OAuth client is created, you'll be presented with a client ID and client secret. These are the credentials your Rails application will use to authenticate with Google.

10. **Download the credentials (Optional):**
    - You can download the credentials as a JSON file. This file will contain information such as the client ID and client secret. Keep this file secure and do not expose it in your application code.

Now you have the OAuth 2.0 client credentials needed for authentication in your Rails application. Make sure to replace the placeholder values in your Rails application with the actual client ID and client secret obtained from the Google Cloud Console.
