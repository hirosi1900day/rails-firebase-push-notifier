class Notification
  class << self
    # Firebase CloudMessaging HTTP v1
    def fcm_notify
      scope = 'https://www.googleapis.com/auth/firebase.messaging'
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open("#{Rails.root.to_s}/google-services.json"),
        scope: scope,
      )

      access_token = authorizer.fetch_access_token!

      url = "https://fcm.googleapis.com/v1/projects/notifirt/messages:send"

      request_body = {
        message: {
          token: "[ 通知を出したい端末ID ]",
          data: {
            data1: "データ1",
            data2: "データ2",
            data3: "データ3",
          },
          notification: {
            title: "タイトル",
            body: "本文"
          },
        }
      }
      conn = Faraday.new(url: url)
      conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer " + access_token["access_token"].to_s
        req.body = request_body.to_json
      end
    end
  end
end
