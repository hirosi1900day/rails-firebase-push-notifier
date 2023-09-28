class Notification
    class << self
    # Firebase CloudMessaging HTTP v1
    def fcm_connection
        scope = 'https://www.googleapis.com/auth/firebase.messaging'
        google_application_credentials_path = Rails.root.join('config', 'mineral', Rails.configuration.x.app.mineral.service_account_key)
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(google_application_credentials_path),
          scope: scope,
        )

        access_token = authorizer.fetch_access_token!

        FCM.new(
        access_token,
        google_application_credentials_path,
        Rails.configuration.x.app.mineral.project_id
        )
    end

    def fcm_push_notification(connection:, device_token:, text:, badge_count: 0)
        message = generate_json_message(device_token:, text:, badge_count:)
        connection.send_v1(message)
    end

    def generate_json_message(device_token:, text:, badge_count:)
        {
        # 'topic': "89023", # OR token if you want to send to a specific device
        'token': device_token,
        'data': {
            payload: {
            data: {
                id: 1,
            },
            }.to_json,
        },
        'notification': {
            title: Rails.configuration.x.app.dietplus_pro.app_name,
            body: text,
        },
        'android': {},
        'apns': {
            payload: {
            aps: {
                sound: "default",
                category: Time.zone.now.to_i.to_s,
                badge: badge_count,
            },
            },
        },
        'fcm_options': {
            analytics_label: 'Label',
        },
        }
    end
    end

    def converted_time_content(wakeup_time:)
    add_hours = (id == 3 ? 1.hour : 2.hours)
    content.gsub(/(\d+:\d{2})/, (wakeup_time + after_wakeup_time_hour_number.hours + add_hours).strftime('%k:%M').strip)
    end
end
