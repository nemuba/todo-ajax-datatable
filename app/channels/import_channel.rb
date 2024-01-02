class ImportChannel < ApplicationCable::Channel
  def subscribed
    stream_from "import_channel"
  end
end
