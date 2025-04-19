import subprocess


def send_notification(title: str, message: str):
    """
    Sends a desktop notification using the notify-send command.

    :param title: Title of the notification
    :param message: Body of the notification
    """
    try:
        # Call the 'notify-send' command to send the notification
        subprocess.run(["notify-send", "-t", "5000", title, message], check=True)
        print(f"Notification sent: {title} - {message}")
    except subprocess.CalledProcessError as e:
        print(f"Error sending notification: {e}")
