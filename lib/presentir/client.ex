defprotocol Presentir.Client do
  def send_message(client, message)
  def send_slide(client, slide)
  def disconnect(client)
end