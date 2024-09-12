# app/services/binance_web_socket.rb
require 'faye/websocket'
require 'eventmachine'
require 'json'

class PriceUpdateService
  def initialize
    @url = 'wss://stream.binance.com:9443/ws/btcusdt@trade'
  end

  def run
    EM.run do
      ws = Faye::WebSocket::Client.new(@url)

      ws.on :open do |event|
        puts "WebSocket connection opened"
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)
        process_message(data)
      end

      ws.on :close do |event|
        puts "WebSocket connection closed"
        EM.stop
      end
    end
  end

  private

  def process_message(data)
    # Implement your logic to handle incoming data
    # Example: Store trade data in the database, notify users, etc.
    puts data, 'dddddddddddddddddddddddddddd'
    # not sure if we have to track the direction in which the bitcoin is moving in the alerts
    # assuming that reaching the exact price is what is required from the wording. 
    alerts = Alert.where(cryptocurrency: 'BTC', target_price: data['p'], status: :created)
    alerts.each do |alert|
      if price >= alert.target_price
        send_email(alert)
        alert.update(status: :triggered)
        puts "alert: reached #{alert.name}, crypto: #{alert.cryptocurrency}, price: #{alert.target_price}"
      end
    end
    puts "Received message: #{data.inspect}"
  end

  def send_email(alert)
    AlertMailer.price_alert(alert).deliver_now
  end
  
end
